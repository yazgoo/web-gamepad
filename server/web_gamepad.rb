#!/bin/env ruby
load 'web_input.rb'
load 'virtual_gamepad.rb'
VirtualGamePad.new "test2" do |pad|
    WebInput.new do |msg, arg|
        exit if msg == "quit"
        axes = {"x" => ABS_X, "y" => ABS_Y}
        if axes.include? msg
            pad << JoyEvent.new(axes[msg], arg.to_i) << SynEvent.new
        end
#        {ABS_Y => {"g"=>-32767, "d"=>32767, "s"=>0},
#         ABS_X => {"l"=>-32767, "r"=>32767, "_"=>0}}.each do |k, v|
#            if v.keys.include? msg
#                pad << JoyEvent.new(k, v[msg]) << SynEvent.new
#            end
#        end
        buttons = {"a" => BTN_A, "b" => BTN_B,
                   "x" => BTN_X, "y" => BTN_Y}
        i = msg.downcase
        if buttons.include? i
            pad << KeyEvent.new(buttons[i], 
                                i == msg ? 0 : 1)
            pad << SynEvent.new
        end
    end
end

