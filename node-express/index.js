const express = require('express');
const Git = require('nodegit');

const app = express();

app.get("/get_git_program/:rootPath/:commitId", async (req, res) => {
  const { rootPath, commitId } = req.params;
  const files = await getGitProgram(rootPath, commitId);

  res.send(files)
})

function start () {
  try {
    app.listen({ port: 3000 });
  } catch (error) {
    console.error(error)
    process.exit(1);
  }
}
start();

// ----------------------------------------------------------------
// Handlers
// ----------------------------------------------------------------
/**
 * 
 * @param {string} rootPath 
 * @param {string} commitId 
 */
async function getGitProgram(rootPath, commitId) {
  const repository = await Git.Repository.open(rootPath);
  const commit = await Git.Commit.lookup(repository, commitId);
  const tree = await Git.Tree.lookup(repository, commit.treeId());
  const fileEntries = await getAllFileEntriesInTree(tree);
  const files = (await Promise.all((fileEntries).map(async (entry) => {
    const blob = await entry.getBlob();
    const content = blob.content().toString();
    return {
      content,
      filePath: entry.path(),
    };
  }))).filter((file) => !!file);

  return files;
}

/**
 * 
 * @param {Git.Tree} tree 
 * @returns {Promise<Git.TreeEntry[]>}
 */
async function getAllFileEntriesInTree(tree) {
  const entries = [];
  await Promise.all(tree.entries().map(async (entry) => {
    if (entry.isFile()) entries.push(entry);
    else if (entry.isDirectory()) entries.push(...await getAllFileEntriesInTree(await entry.getTree()));
  }));
  return entries;
};