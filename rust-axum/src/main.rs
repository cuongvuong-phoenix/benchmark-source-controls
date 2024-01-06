use std::path::{self};

use anyhow::Error;
use axum::{extract::Path, http::StatusCode, response::IntoResponse, routing::get, Json, Router};
use git2::{ObjectType, Oid, Repository, Tree, TreeEntry, TreeWalkMode, TreeWalkResult};
use serde::Serialize;

#[tokio::main]
async fn main() {
    let app = Router::new().route(
        "/get_git_program/:root_path/:commit_id",
        get(get_git_program),
    );

    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await
        .unwrap();
    axum::serve(listener, app).await.unwrap();
}

// ----------------------------------------------------------------
// Handlers
// ----------------------------------------------------------------
#[derive(Serialize)]
struct GitProgramFile {
    file_path: String,
    content: String,
}

async fn get_git_program(
    Path((root_path, commit_id)): Path<(String, String)>,
) -> Result<Json<Vec<GitProgramFile>>, AppError> {
    let repo = Repository::open(root_path)?;
    let commit = repo.find_commit(Oid::from_str(&commit_id)?)?;
    let tree = commit.tree()?;
    let mut files: Vec<GitProgramFile> = vec![];

    traverse_git_files(&repo, &tree, None, &mut |path, entry| {
        files.push(GitProgramFile {
            file_path: path.to_string(),
            content: std::str::from_utf8(
                entry.to_object(&repo).unwrap().as_blob().unwrap().content(),
            )
            .unwrap_or_default()
            .to_string(),
        });
    })?;

    Ok(Json(files))
}

fn traverse_git_files(
    repo: &Repository,
    tree: &Tree,
    parent_path: Option<&str>,
    cb: &mut impl FnMut(&str, &TreeEntry),
) -> Result<(), git2::Error> {
    tree.walk(TreeWalkMode::PreOrder, |_, entry| {
        let path =
            path::Path::new(parent_path.unwrap_or_default()).join(entry.name().unwrap_or_default());
        let path = path.to_str().unwrap_or_default();

        match entry.kind() {
            Some(ObjectType::Blob) => {
                cb(path, entry);
                TreeWalkResult::Ok
            }
            Some(ObjectType::Tree) => {
                let object = entry.to_object(repo).unwrap();
                let sub_tree = object.as_tree().unwrap();
                traverse_git_files(repo, sub_tree, Some(path), cb).unwrap();

                TreeWalkResult::Skip
            }
            _ => TreeWalkResult::Skip,
        }
    })
}

// ----------------------------------------------------------------
// Errors
// ----------------------------------------------------------------
#[derive(thiserror::Error, Debug)]
enum AppError {
    #[error("Git Error: {0}")]
    Git(#[from] git2::Error),
    #[error(transparent)]
    Other(#[from] Error),
}

impl IntoResponse for AppError {
    fn into_response(self) -> axum::response::Response {
        (StatusCode::INTERNAL_SERVER_ERROR, self.to_string()).into_response()
    }
}
