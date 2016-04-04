#!/usr/bin/env ruby -Ku
# coding: utf-8

require './brainfxxk'

class BF < Brainfxxk
end

BF.new(ARGF.read, keys).run
