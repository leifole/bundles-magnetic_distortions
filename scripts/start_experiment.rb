#! /usr/bin/env ruby

require 'rock/bundle'
require 'pry'
include Orocos


Bundles.initialize
Bundles.conf.load_dir(Bundles.find_dir('config'))

Orocos.run 'servo_dynamixel::Task' => 'servo', 'mc_maxon_epos::Task' => 'epos', :output => nil do 
    servo = Orocos.get 'servo'
    epos = Orocos.get 'epos'


    Orocos.conf.apply(servo)

    servo.device = "serial:///dev/ttyUSB0:57600"
    servo.baudrate = 57600
    #Orocos.load_typekit('servo_dynamixel')

    #sc = Types.servo_dynamixel.ServoConfiguration.new
    #sc.name = "servo_0"
    #sc.id = 1
    #sc.cwComplianceMargin = 1
    #sc.ccwComplianceMargin = 1
    #sc.cwComplianceSlope = 32
    #sc.ccwComplianceSlope = 32
    #sc.punch = 32
    #sc.positionScale = 195.383 # 1023/(300/180*3.141) 
    #sc.positionOffset = 0
    #sc.positionRange = 4095
    #sc.speedScale = 139.58 # 1023/(70/60*3.141*2) 
    #sc.effortScale = 361.48 # 1023/2.83 

    #servo.servo_config.push(sc)

    #binding.pry

    epos.position_list = [0.02,0.0]
    epos.ticks2meter = 1.85e-8

    servo.configure
    epos.configure

    servo.start
    epos.start

    servo_writer = servo.command.writer

    # wait for input
    puts "start experiment: <number of repeats>"
    while not (cmd = $stdin.readline.chomp).empty? do

    epos.startPositionProfile


        (1..cmd.to_i).each do |i|

            joints = Types::Base::Samples::Joints.new
            joints.names << "servo_0"
            joint_state = Types::Base::JointState.new
            joint_state.position = Math::PI / i
            joints.elements << joint_state
            servo_writer.write joints
            sleep 2
        end
    end
end

