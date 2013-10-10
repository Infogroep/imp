require 'drb/drb'
require_relative 'player'

DRb.start_service("drbunix:/var/tmp/imp-player.socket",Player.new)
DRb.thread.join
