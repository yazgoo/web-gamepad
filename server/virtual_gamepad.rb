require 'awesome_print'
require 'cstruct'
UI_SET_EVBIT = 1074025828
UI_SET_KEYBIT = 1074025829
UI_SET_RELBIT = 1074025830
UI_SET_ABSBIT = 1074025831
EV_SYN = 0
EV_KEY = 1
EV_REL = 2
EV_ABS = 3
SYN_REPORT = 0
KEY_RESERVED = 0
KEY_ESC	= 1
REL_X = 0
REL_Y = 1
REL_RX = 3
REL_RY = 4
ABS_X = 0
ABS_Y = 1
ABS_RX = 3
ABS_RY = 4
BTN_LEFT = 0x110
BTN_RIGHT = 0x111
BTN_FORWARD = 0x115
BTN_BACK = 0x116
BTN_JOYSTICK = 0x120
BTN_A = 0x130
BTN_B = 0x131
BTN_X = 0x133
BTN_Y = 0x134
BTN_TL = 0x136
BTN_TR = 0x137
BTN_TL2 = 0x138
BTN_TR2 = 0x139
BTN_SELECT = 0x13a
BTN_START = 0x13b
BTN_THUMBL = 0x13d
BTN_THUMBR = 0x13e
UINPUT_MAX_NAME_SIZE = 80
ABS_CNT = 64
BUS_VIRTUAL = 6
UI_DEV_CREATE = 21761
UI_DEV_DESTROY = 21762
class UInputUserDev < CStruct
    class Id < CStruct
        uint16 :bustype
        uint16 :vendor
        uint16 :product
        uint16 :version
    end
    char :name,[UINPUT_MAX_NAME_SIZE]
    Id :id
    uint32 :ff_effects_max
    int32 :absmax,[ABS_CNT]
    int32 :absmin,[ABS_CNT]
    int32 :absfuzz,[ABS_CNT]
    int32 :absflat,[ABS_CNT]
end
class InputEvent < CStruct
    class Timeval < CStruct
        int64 :tv_sec
        int64 :tv_usec
    end
    Timeval :timeval
    uint16 :type
    uint16 :code
    int32 :value
end
class VirtualGamePad
    attr_reader :keys, :absolute_axes
    def << what
        @f.syswrite what.data
        self
    end
    def initialize name, &block
        file = "/dev/uinput"
        @keys = [ KEY_RESERVED, KEY_ESC,
                    BTN_LEFT, BTN_RIGHT, BTN_FORWARD, BTN_BACK,
                    BTN_A, BTN_B, BTN_X, BTN_Y,
                    BTN_TL, BTN_TR, BTN_TL2, BTN_TR2,
                    BTN_SELECT, BTN_START, BTN_THUMBL, BTN_THUMBR,
                    BTN_JOYSTICK ]
        File.open(file, File::NONBLOCK + File::WRONLY) do |f|
            @f = f
            @absolute_axes = [ABS_X, ABS_Y, ABS_RX, ABS_RY]
            [
                [UI_SET_EVBIT,  [EV_SYN]],
                [UI_SET_EVBIT,  [EV_ABS]],
                [UI_SET_ABSBIT, absolute_axes],
                [UI_SET_EVBIT,  [EV_KEY]],
                [UI_SET_KEYBIT, @keys]
            ].each { |o| o[1].each { |v| f.ioctl o[0], v } }
            self << UInputUserDev.new do |dev|
                dev.name = name
                dev.id.bustype = BUS_VIRTUAL
                dev.id.vendor = 0x1234
                dev.id.product = 0xfedc
                dev.id.version = 1
                absolute_axes.each do |i|
                    dev.absmin[i] = -32767
                    dev.absmax[i] = 32767
                end
            end
            f.ioctl UI_DEV_CREATE
            while instance_exec(self, &block) != false; end
            f.ioctl UI_DEV_DESTROY, nil
        end
    end
end
class GInputEvent
    def initialize type, code, value
        @evt = InputEvent.new
        @evt.type = type
        @evt.code = code
        @evt.value = value
    end
    def data
        @evt.data
    end
end
class KeyEvent < GInputEvent
    def initialize code, value
        super EV_KEY, code, value
    end
end
class SynEvent < GInputEvent
    def initialize
        super EV_SYN, SYN_REPORT, 0
    end
end
class JoyEvent < GInputEvent
    def initialize axis, value
        super EV_ABS, axis, value
    end
end

