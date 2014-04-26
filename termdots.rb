require "RMagick"

include Magick

FILENAME = ARGV[0]
ELEM_STR = "  "
COLOR_MODE = 2  # 1: 16colors, 2: 256colors

def output_image(file_name)

    cg = ColorGenerator.new(COLOR_MODE)
    cg.set_transparent_color(0, 0, 0)

    img = ImageList.new(file_name)
    for y in 0...img.rows
        for x in 0...img.columns
            src = img.pixel_color(x, y)
            r = src.red / 256
            g = src.green / 256
            b = src.blue / 256

            print cg.convert(r, g, b) + get_elem_str + cg.clear_color
        end
        puts ""
    end
end

def get_elem_str
    return ELEM_STR
end

def main
    file_name = FILENAME.to_s
    if !File.exists?(file_name)
        puts "image file not found."
        exit
    end
    output_image(file_name)
end


# =========================
# Color generator class
# =========================
class ColorGenerator

    # color mode
    COLOR_MODE_16 = 1
    COLOR_MODE_256 = 2

    # color => [r, g, b]
    CT_RGB = {
        :black     => [0, 0, 0],
        :red       => [205, 0, 0],
        :green     => [0, 205, 0],
        :yellow    => [205, 205, 0],
        :blue      => [0, 0, 238],
        :magenta   => [205, 0, 205],
        :cyan      => [0, 205, 205],
        :gray      => [229, 229, 229],
        :darkgray  => [127, 127, 127],
        :l_red     => [255, 0, 0],
        :l_green   => [0, 255, 0],
        :l_yellow  => [255, 255, 0],
        :l_blue    => [92, 92, 255],
        :l_magenta => [255, 0, 255],
        :l_cyan    => [0, 255, 255],
        :white     => [255, 255, 255]
    }

    # color => ANSI escape code
    CT_ANSI = {
        :black     => "\033[40m",
        :red       => "\033[41m",
        :green     => "\033[42m",
        :yellow    => "\033[43m",
        :blue      => "\033[44m",
        :magenta   => "\033[45m",
        :cyan      => "\033[46m",
        :gray      => "\033[47m",
        :darkgray  => "\033[100m",
        :l_red     => "\033[101m",
        :l_green   => "\033[102m",
        :l_yellow  => "\033[103m",
        :l_blue    => "\033[104m",
        :l_magenta => "\033[105m",
        :l_cyan    => "\033[106m",
        :white     => "\033[107m"
    }


    def initialize(mode)
        @mode = mode
        @tr = -1
        @tg = -1
        @tb = -1
    end

    def set_transparent_color(r, g, b)
        @tr = r
        @tg = g
        @tb = b
    end

    def transparent_color?(r, g, b)
        return r == @tr && g == @tg && b == @tb
    end

    # r,g,b = (0...255)
    def convert(r, g, b)
        if @mode == COLOR_MODE_16
            return convert16(r, g, b)
        elsif @mode == COLOR_MODE_256
            return convert256(r, g, b)
        else
            return ""
        end
    end

    def convert16(r, g, b)
        if transparent_color?(r, g, b)
            return ""
        end

        diff_min = 255 * 3
        ret = CT_ANSI[:black]
        CT_RGB.each do |color, rgb|
            diff = (r - rgb[0]).abs + (g - rgb[1]).abs + (b - rgb[2]).abs
            if diff < diff_min
                ret = CT_ANSI[color]
                diff_min = diff
            end
        end

        return ret
    end

    def convert256(r, g, b)
        if transparent_color?(r, g, b)
            return ""
        end

        code = (r * 5 / 255 * 36) + (g * 5 / 255 * 6) + (b * 5 / 255) + 16
        ret = "\033[48;5;" + code.to_s + "m"

        return ret
    end

    def clear_color
        return "\033[0m"
    end

    def test
        puts "\033[40m \033[41m \033[42m \033[43m \033[44m \033[45m \033[46m \033[47m \033[0m"
        puts "\033[100m \033[101m \033[102m \033[103m \033[104m \033[105m \033[106m \033[107m \033[0m"
    end
end

main

