# coding: utf-8

require "./libao/*"

@[Link("ao")]
lib LibAO
  alias CInt = LibC::Int
  alias CLong = LibC::Long
  alias CFloat = LibC::Float
  alias CDouble = LibC::Double
  alias CChar = LibC::Char
  alias Matrix = CChar*
  alias Device = Void*

  enum Byte_Format
    AO_FMT_LITTLE
    AO_FMT_BIG
    AO_FMT_NATIVE
  end

  struct Format
    bits : CInt
    rate : CInt
    channels : CInt
    byte_format : CInt
    matrix : CChar*
  end

  struct Options
    key   : CChar*
    value : CChar*
    next  : Options*
  end

  fun init = ao_initialize() : Void
  fun exit = ao_shutdown() : Void
  fun default_driver_id = ao_default_driver_id() : CInt
  fun open_live = ao_open_live(driver_id : CInt, sample_format : Format*, options : Options*) : Device*
  fun play = ao_play(device : Device*, output_samples : CChar*, num_bytes : CInt) : CInt
end

module Libao
  class Ao
    def initialize
      LibAO.init
      @id = LibAO.default_driver_id
      @format = LibAO::Format.new
      @options = LibAO::Options.new
    end

    def set_format(bits, rate, channels, byte_format, matrix)
      @format.bits = bits
      @format.rate = rate
      @format.channels = channels
      @format.byte_format = byte_format
      @format.matrix = matrix
    end

    def open_live
      @dev = LibAO.open_live(@id, pointerof(@format), nil);
    end

    def play(buf, done)
      LibAO.play(@dev, buf, done);
    end

    def exit
      LibAO.exit
    end
  end
end
