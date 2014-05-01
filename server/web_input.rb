class WebInput
    def initialize
        require 'sinatra/base'
        (Sinatra.new do
            set :bind, '0.0.0.0'
            configure do
                  mime_type :js, 'text/javascript'
            end
            put '/:cmd' do |cmd|
                p cmd
                yield cmd
            end
            get '/grid' do
                File.read(File.join('../client', 'grid.html'))
            end
            get '/' do
                File.read(File.join('../client', 'gamepad.html'))
            end
            get '/client.js' do
                content_type :js
                File.read(File.join('../client', 'client.js'))
            end
        end).run!
    end
end
