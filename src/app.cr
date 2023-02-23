require "baked_file_system"
require "http/server"

HOST = "127.0.0.1"
PORT = 8080

# URL to archive path mapping
def get_file_from_url?(url : String) : String 
  if url == "/" || url == ""
    url = "/index.html"
  end
  path = url
  file = nil
  begin
    file = FileStorage.get path
    return file.gets_to_end
  rescue BakedFileSystem::NoSuchFileError
    puts "File #{path} is missing"
    return "Path: #{path} not found!"
  end   
end

# Archive
class FileStorage
  extend BakedFileSystem
  bake_folder "../public"
end

# Server using URL to archive path mapping
server = HTTP::Server.new do |context|
  context.response.print get_file_from_url?(context.request.path)
end

# Running server
puts "Listening on http://#{HOST}:#{PORT}"
server.bind_tcp HOST , PORT
server.listen

