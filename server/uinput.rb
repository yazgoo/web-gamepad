#!/bin/env ruby
load 'virtual_gamepad.rb'
VirtualGamePad.new("test2") do
    (puts; next false) if (action = [print("$ "), gets][1]).nil?
    if keys.include? action.to_i
        self << KeyEvent.new(action.to_i, 1)
        self << SynEvent.new
    elsif (a = action.split(" ")).size == 2 and
        (absolute_axes-[0]).include? a[0].to_i or a[0] == "0"
        self << JoyEvent.new(action.to_i, a[1].to_i)
        self << SynEvent.new
    else
        puts "enter either:
          - key number in #{keys.join(", ")}
          - axis in #{absolute_axes.join(", ")}
          - ^D to quit"
    end
end
