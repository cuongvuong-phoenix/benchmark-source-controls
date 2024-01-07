require 'sinatra'
require 'rugged'
require 'oj'

get '/get_git_program' do
  repository = Rugged::Repository.new(params[:root_path])
  commit = repository.lookup(params[:commit_id])
  files = []

  commit.tree.walk_blobs(:preorder) do |root, entry|
    files << {
      'file_path' => File.join(root, entry[:name]),
      'content' => repository.lookup(entry[:oid]).content
    }
  end

  Oj.dump(files)
end
