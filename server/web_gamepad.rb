#!/bin/env ruby
load 'web_input.rb'
load 'virtual_gamepad.rb'
VirtualGamePad.new "test2" do |pad|
    WebInput.new do |msg|
        exit if msg == "quit"
        {ABS_Y => {"a"=>-32767, "d"=>32767, "s"=>0},
         ABS_X => {"l"=>-32767, "r"=>32767, "_"=>0}}.each do |k, v|
            if v.keys.include? msg
                pad << JoyEvent.new(k, v[msg]) << SynEvent.new
            end
        end
    end
end

