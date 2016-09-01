#!/usr/bin/env ruby

require 'orocos'

include Orocos
Orocos.initialize

if ARGV.length == 0
    puts "No position given"
    exit 1
end

epos = Orocos.get('epos')

writer = epos.joint_command.writer
jc = writer.new_sample
jc.position = ARGV[0].to_f
writer.write(jc)

