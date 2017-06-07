import RPi.GPIO as GPIO
import subprocess

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)

GPIO.setup(11, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(13, GPIO.IN, pull_up_down=GPIO.PUD_UP)

player = None
audios = {False: 'bgm.wav', True: 'gg.wav'}
current_audio = ''

while True:
	enable = GPIO.input(11)
	sel = GPIO.input(13)

	if not enable and player and player.poll() == None:
		player.kill()
		player = None
		current_audio = ''
		print 'killed'

	if current_audio != audios[sel] and enable:
		if player and player.poll() == None:
			player.kill()
		player = subprocess.Popen(['/usr/bin/mplayer', audios[sel]])
		current_audio = audios[sel]
		print audios[sel]
