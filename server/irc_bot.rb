require 'net/yail'
class IRCBot < Net::YAIL
    def initialize server, channel, &block
        super(
            :address    => server,
            :username   => 'testouille',
            :realname   => 'testouille',
            :nicknames  => ['testouille']
        )
        on_welcome proc { |event| join('#' + channel) }
        hearing_msg do |event|
            @msg = event.message
            instance_exec(self, &block)
        end
        start_listening!
    end
end

