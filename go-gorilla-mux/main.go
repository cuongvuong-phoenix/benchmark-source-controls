package main

import (
	"encoding/json"
	"net/http"

	"github.com/go-git/go-git/v5"
	"github.com/go-git/go-git/v5/plumbing"
	"github.com/go-git/go-git/v5/plumbing/object"
	"github.com/gorilla/mux"
)

func main() {
	r := mux.NewRouter()

	r.HandleFunc("/get_git_program", func(w http.ResponseWriter, r *http.Request) {
		query := r.URL.Query()
		repo, _ := git.PlainOpen(query.Get("root_path"))
		commit, _ := repo.CommitObject(plumbing.NewHash(query.Get("commit_id")))
		tree, _ := commit.Tree()
		var files []GitProgramFile

		tree.Files().ForEach(func(f *object.File) error {
			content, _ := f.Contents()
			files = append(files, GitProgramFile{FilePath: f.Name, Content: content})

			return nil
		})

		res, _ := json.Marshal(files)
		w.Write(res)
	}).Methods("GET")

	http.Handle("/", r)
	http.ListenAndServe(":3000", r)
}

type GitProgramFile struct {
	FilePath string `json:"file_path"`
	Content  string `json:"content"`
}
