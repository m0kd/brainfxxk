#!/usr/bin/env ruby
# coding: utf-8

require './brainfxxk'

class BF < Brainfxxk
end

BF.new(ARGF.read).run
