#!/usr/bin/env ruby -Ku
# coding: utf-8

class Brainfxxk

  def initialize(code, opts={})
    @code = code
    @default_keys = {inc: "+", dec: "-", nxt: ">", prv: "<", put: ".", get: ",", lst: "[", led: "]"}
    if opts.empty?
      @keys = @default_keys
    else
      @keys = opts
    end
  end

  def run
    @tokens = compile(@code).split("")
    @jumps  = check_pair(@tokens)
    @cell   = []
    @pntr   = 0
    @crsr   = 0
    while @pntr < @tokens.size
      case @tokens[@pntr]
      when "+"
        increment
      when "-"
        decrement
      when ">"
        move_right
      when "<"
        move_left
      when "."
        put_char
      when ","
        get_char
      when "["
        loop_start
      when "]"
        loop_end
      end

      @pntr += 1
    end
  end

  private

  def compile(code)
    i = 0
    compiled_code = ''

    invert_keys = @keys.invert
    reg = Regexp.compile "(#{@keys.values.map{|v| Regexp.quote(v) }.join('|')})"

    while matches = reg.match(code, i)
      key = invert_keys[matches[1]]
      compiled_code += @default_keys[key]
      i = code.index(reg, i) + matches[1].length
    end
    compiled_code
  end

  def increment
    @cell[@crsr] ||= 0
    @cell[@crsr] += 1
  end

  def decrement
    @cell[@crsr] ||= 0
    @cell[@crsr] -= 1
  end

  def move_right
    @crsr += 1
  end

  def move_left
    @crsr -= 1
  end

  def put_char
    n = (@cell[@crsr] || 0)
    print n.chr
  end

  def get_char
    @cell[@crsr] = $stdin.getc.ord
  end

  def loop_start
    if @cell[@crsr] == 0
      @pntr = @jumps[@pntr]
    end
  end

  def loop_end
    if @cell[@crsr] != 0
      @pntr = @jumps[@pntr]
    end
  end

  def check_pair(tokens)
    jump_list = {}
    start_point = []

    tokens.each_with_index do |c, i|
      if c == @default_keys[:lst]
        start_point.push(i)
      elsif c == @default_keys[:led]
        from = start_point.pop
        to = i

        jump_list[from] = to
        jump_list[to] = from
      end
    end
    jump_list
  end
end
