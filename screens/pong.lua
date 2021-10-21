local fennel = require("lib/fennel")
table.insert(package.loaders or package.searchers, fennel.search)
-- local hello_world = require("lib/hello")
local pong_fennel = require("lib/pong")

local asdf = require("lib/asdf")

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

function sign(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return 1
	end
end

local Pong = {
	extends = "Node2D",
	
	left_up = false,
	left_down = false,

	right_up = false,
	right_down = false,

	ball_vel = Vector2(math.random(5, 10), math.random(5, 10))
}

function Pong:_ready()
--	local paddle = GD.load("res://entities/paddle.tscn"):instance()
	self.left_paddle = self:get_node("LeftPaddle")
	self.right_paddle = self:get_node("RightPaddle")
	
	self.ball = self:get_node("Ball")
	
	local r1 = math.random(-1, 1)
	if r1 < 0 then
		self.ball_vel.x = -self.ball_vel.x
	end

	local r2 = math.random(-1, 1)
	if r2 < 0 then
		self.ball_vel.y = -self.ball_vel.y
	end
	-- local pong = pong_fennel.PongFennel
--	self.left_paddle.script = pong
	-- self.left_paddle:script(pong)

	-- print(dump(pong))
	-- print(dump(self.left_paddle))
end

function Pong:_process(delta)
	-- Cannot set x,y values on nested global_position
	local difference = 0
	if self.left_up then
		difference = self.left_paddle.global_position.y - 10 * delta * 60
		local g_pos = self.left_paddle.global_position
		g_pos.y = difference
		self.left_paddle.global_position = g_pos
	end
	if self.left_down then
		difference = self.left_paddle.global_position.y + 10 * delta * 60
		local g_pos = self.left_paddle.global_position
		g_pos.y = difference
		self.left_paddle.global_position = g_pos
	end

	if self.right_up then
		difference = self.right_paddle.global_position.y - 10 * delta * 60
		local g_pos = self.right_paddle.global_position
		g_pos.y = difference
		self.right_paddle.global_position = g_pos
	end
	if self.right_down then
		difference = self.right_paddle.global_position.y + 10 * delta * 60
		local g_pos = self.right_paddle.global_position
		g_pos.y = difference
		self.right_paddle.global_position = g_pos
	end
end

function Pong:_physics_process(delta)
	local collision = self.ball:move_and_collide(self.ball_vel * delta * 20)
	if collision ~= nil then
		local collider = collision.collider
		print(collider.name)
		if collider:is_in_group("Wall") then
			local s = -sign(self.ball_vel.y)
			self.ball_vel.y = math.random(10 * s, 5 * s)
			print("wall")
		elseif collider:is_in_group("Paddle") then
			local s = -sign(self.ball_vel.x)
			self.ball_vel.x = math.random(10 * s, 5 * s)
			print("paddle")
		end
	end
end

function Pong:_unhandled_input(event)
	if event:is_action_pressed("left_move_up") then
		self.left_up = true
	elseif event:is_action_released("left_move_up") then
		self.left_up = false
	
	elseif event:is_action_pressed("left_move_down") then
		self.left_down = true
	elseif event:is_action_released("left_move_down") then
		self.left_down = false

	elseif event:is_action_pressed("right_move_up") then
		self.right_up = true
	elseif event:is_action_released("right_move_up") then
		self.right_up = false

	elseif event:is_action_pressed("right_move_down") then
		self.right_down = true
	elseif event:is_action_released("right_move_down") then
		self.right_down = false
	end
end

return Pong
