local Asdf = {
	extends = "Node",
	class_name = "Asdf"
}

function Asdf:_ready()
	local os_name = OS:get_name()
	print(os_name)
end

return Asdf
