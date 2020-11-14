function love.load()
	FONT_SIZE = 20

	love.window.setTitle("nowplaying-widget")
	love.window.setMode(1280, 2*FONT_SIZE)
	--love.window.setMode(1280, 720)

	NOW_PLAYING_FONT = love.graphics.newFont(FONT_SIZE)

	total_time = 0

	song_update_timer = 0
	SONG_UPDATE_INTERVAL = 10 -- seconds

	bubble_timer = 0
	BUBBLE_UPDATE_INTERVAL = 1/12 -- seconds

	noise_v = 0
	noise_a = 0
	noise_b = 0
	noise_speed_reduction = 8

	currently_playing = ""
	obtain_currently_playing()
	grid = {}
end

--[[XXX should happen in a separate thread?]]
function obtain_currently_playing()
	local fd = io.popen("/usr/bin/osascript ./query.applescript", "r")
	currently_playing = fd:read("*l")
	fd:close()
end

function love.update(dt)
	total_time = total_time + dt
	song_update_timer = song_update_timer + dt

	bubble_timer = bubble_timer + dt

	if (song_update_timer >= SONG_UPDATE_INTERVAL) then
		song_update_timer = song_update_timer - SONG_UPDATE_INTERVAL
		obtain_currently_playing()
	end

	noise_v = love.math.noise(total_time/noise_speed_reduction)

	if (bubble_timer >= BUBBLE_UPDATE_INTERVAL) then
		bubble_timer = bubble_timer - BUBBLE_UPDATE_INTERVAL

		for x = 1, love.graphics.getWidth()/8 do
			for y = 1, love.graphics.getHeight()/8 do
				grid[x] = grid[x] or {}
				grid[x][y] = love.math.noise(x + love.math.random(), y + love.math.random())
			end
		end
	end
end

function love.draw()
	love.graphics.setColor(noise_v-0.1, noise_v-0.25, noise_v-0.1, 1)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

	for x = 1, #grid do
		for y = 1, #grid[x] do
			local shade = grid[x][y]
			love.graphics.setColor(0.9, 0, 1-shade, 0.05)
			love.graphics.circle("fill", x*8 + shade*2, y*8 + shade, 20)
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(NOW_PLAYING_FONT)
	love.graphics.print(currently_playing, 4, love.graphics.getHeight() - NOW_PLAYING_FONT:getHeight())
end
