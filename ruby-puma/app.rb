require 'sinatra'
require 'rugged'
require 'oj'

get '/get_git_program/:root_path/:commit_id' do |root_path, commit_id|
  repository = Rugged::Repository.new(root_path)
  commit = repository.lookup(commit_id)
  files = []

  commit.tree.walk_blobs(:preorder) do |root, entry|
    files << {
      file_path: File.join(root, entry[:name]),
      content: repository.lookup(entry[:oid]).content
    }
  end

  Oj.dump(files)
end
