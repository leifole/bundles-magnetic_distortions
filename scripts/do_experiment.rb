#!/usr/bin/env ruby

require 'orocos'

include Orocos
Orocos.initialize

epos = Orocos.get('epos')

epos.startPositionProfile
