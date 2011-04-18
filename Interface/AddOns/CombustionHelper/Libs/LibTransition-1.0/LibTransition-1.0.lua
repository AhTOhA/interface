--[[ LibTransition-1.0
Revision: $Rev: 15 $
Author(s): Humbedooh
Description: PowerPoint goodness for your addon.
Dependencies: LibStub
License: All Rights Reserved.
]]

local tinsert,tremove,pow,sqrt,atan2,abs,floor,min,max,deg = table.insert, table.remove,math.pow,math.sqrt,math.atan2,math.abs,math.floor,math.min,math.max,math.deg;
local gravity, altitude, elasticity, jiffy = 9.81, 20, 9.81/18, 0.04;
local LITRANSITION = "LibTransition-1.0"
local LITRANSITION_MINOR = tonumber(("$Rev: 15 $"):match("(%d+)")) or 5000;
assert(LibStub, LITRANSITION .. " requires LibStub.")
local LibTransition = LibStub:NewLibrary(LITRANSITION, LITRANSITION_MINOR)
if not LibTransition then return end
LibTransition.methods = {
	FADEIN = {'duration'},
	FADEOUT = {'duration'}
};
LibTransition.tQueue = {};
LibTransition.cQueue = {};

function LibTransition:GetFrame(frame)
	if ( type(frame) == "string" ) then frame = _G[frame]; end
	assert(type(frame) == "table" and frame.Show, LITRANSITION .. ": Could not find frame object");
	return frame;
end

function LibTransition.runTimer(me, elapsed)
	local now = GetTime();
	for frame, queue in pairs(LibTransition.tQueue) do
		if ( #queue == 0 and not LibTransition.cQueue[frame] ) then
			LibTransition.tQueue[frame] = nil;
		else
			if ( LibTransition.tQueue[frame].running ) then
				if ( #queue == 0 ) then
					LibTransition:Compile(unpack(tremove(LibTransition.cQueue[frame],1)));
					if ( #LibTransition.cQueue[frame] == 0 ) then LibTransition.cQueue[frame] = nil; end
				end
				local when = queue[1].executeTime;
				while (when <= now ) do
					local x,y,ref,alpha,width,height = unpack((tremove(queue,1)).args);
					local j,l = frame:GetCenter();
					local m,n = frame:GetWidth(), frame:GetHeight();
					frame:ClearAllPoints();
					frame:SetWidth(m);
					frame:SetHeight(n);
					frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", j, l);
					if x and y and ref then frame:ClearAllPoints(); frame:SetPoint(ref, UIParent, "BOTTOMLEFT", x, y) end
					if alpha then
						if alpha == 0 then frame:Hide() else frame:Show() frame:SetAlpha(alpha) end
					end
					if width and height then frame:SetWidth(width) frame:SetHeight(height) end
					if ( #queue == 0 ) then when = now+999
					else when = queue[1].executeTime or (now + 1);
					end
				end
			end
		end
	end
end

function LibTransition:Queue(frame, method, ...)
	LibTransition.cQueue[frame] = LibTransition.cQueue[frame] or {};
	tinsert(LibTransition.cQueue[frame], {frame, method:upper(), ...});
end

function LibTransition:Compile(frame, method, ...)
	local now = GetTime();
	--print(frame, method,...);
	if not frame then return now + 1 end
	if not LibTransition.tQueue[frame] then LibTransition.tQueue[frame] = {}; end
	if ( method == "DROP" ) then
		local bounce = select(1, ...);
		local distance = altitude * (frame:GetBottom() / 768);
		local left = frame:GetLeft();
		local speed = 1;
		local duration = 0;
		local xduration = 0;
		while ( true ) do
			duration = duration + jiffy;
			xduration = xduration + jiffy;
			speed = speed + (jiffy*gravity);
			distance = distance - (speed * jiffy);
			if ( distance <= 0 ) then
				distance = 0;
			end
			tinsert(LibTransition.tQueue[frame], {args={left, (distance/altitude)*768, "BOTTOMLEFT"}, executeTime=now});
			if distance == 0 then
				if ( bounce ) then
					speed = speed * -elasticity;
					duration = 0;
					if abs(speed) <= 0.5 then break end
				end
			end
			now = now + jiffy;
		end
	elseif ( method == "FADEIN" ) then
		local duration, stopAlpha = ...;
		local duration = abs(tonumber(duration) or 1);
		local stopAlpha = abs(tonumber(stopAlpha) or 1);
		if duration < jiffy then duration = jiffy end
		local elapsed = 0;
		tinsert(LibTransition.tQueue[frame], {args={nil,nil,nil,0}, executeTime=now});
		while duration > elapsed do
			tinsert(LibTransition.tQueue[frame], {args={nil,nil,nil,(elapsed/duration) * stopAlpha}, executeTime=now});
			now = now + jiffy;
			elapsed = elapsed + jiffy
		end
	elseif ( method == "FADEOUT" ) then
		local duration, stopAlpha = ...;
		local duration = abs(tonumber(duration) or 1);
		local stopAlpha = abs(tonumber(stopAlpha) or 0);
		local startAlpha = frame:GetAlpha();
		if duration < jiffy then duration = jiffy end
		local elapsed = 0;
		while duration > elapsed do
			tinsert(LibTransition.tQueue[frame], {args={nil,nil,nil,(startAlpha * (1 - (elapsed/duration))) + ((elapsed/duration)*stopAlpha)}, executeTime=now});
			now = now + jiffy;
			elapsed = elapsed + jiffy
		end
		tinsert(LibTransition.tQueue[frame], {args={nil,nil,nil,0}, executeTime=now + jiffy});
	elseif ( method == "WAIT" ) then
		local duration = abs(tonumber(select(1,...)) or 1);
		if duration < jiffy then duration = jiffy end
		tinsert(LibTransition.tQueue[frame], {args={}, executeTime=now + duration});
	elseif ( method == "PUSHOUT" ) then
		local direction, duration = select(1,...):upper(), tonumber(select(2,...)) or 1;
		if duration < jiffy then duration = jiffy end
		local x, y = 0, 0
		if		direction == "UP" then y = 768 - frame:GetBottom();
		elseif	direction == "DOWN" then y = 0 - frame:GetTop();
		elseif	direction == "LEFT" then x = 0 - frame:GetRight();
		elseif	direction == "RIGHT" then x = UIParent:GetWidth() - frame:GetLeft();
		end
		local n = 0;
		local a,b = frame:GetLeft(), frame:GetBottom();
		while n < duration do
			n = n + jiffy;
			tinsert(LibTransition.tQueue[frame], {args={a + (x*(n/duration)), b + (y*(n/duration)), "BOTTOMLEFT"}, executeTime=now});
			now = now + jiffy;
		end
	elseif ( method == "PUSHIN" ) then
		local direction, duration = select(1,...):upper(), tonumber(select(2,...)) or 1;
		if duration < jiffy then duration = jiffy end
		local x, y = 0, 0
		if		direction == "UP" then y = 768 - frame:GetBottom();
		elseif	direction == "DOWN" then y = 0 - frame:GetTop();
		elseif	direction == "LEFT" then x = 0 - frame:GetRight();
		elseif	direction == "RIGHT" then x = UIParent:GetWidth() - frame:GetLeft();
		end
		local n = 0;
		local a,b = frame:GetLeft(), frame:GetBottom();
		while n < duration do
			n = n + jiffy;
			tinsert(LibTransition.tQueue[frame], {args={a + x - (x*(n/duration)), b + y - (y*(n/duration)), "BOTTOMLEFT"}, executeTime=now});
			now = now + jiffy;
		end
	elseif ( method == "SQUEEZE" ) then
		local w,h = frame:GetWidth(), frame:GetHeight();
		local a,b = frame:GetCenter();
		local duration, direction = ...;
		local duration = abs(tonumber(duration) or 1);
		local direction = (direction or ""):upper();
		local x,y=0,0
		if duration < jiffy then duration = jiffy end
		if ( direction == "HORIZONTAL" or direction == "HORISONTAL" ) then
			x = w;
		else
			y = h;
		end
		local elapsed = 0;
		while duration > elapsed do
			tinsert(LibTransition.tQueue[frame], {args={a, b, "CENTER",nil, w-(x*(elapsed/duration)), h-(y*(elapsed/duration))}, executeTime=now});
			now = now + jiffy;
			elapsed = elapsed + jiffy
		end
		tinsert(LibTransition.tQueue[frame], {args={a, b, "CENTER",0, w, h}, executeTime=now + jiffy});
	elseif ( method == "STRETCH" ) then
		local w,h = frame:GetWidth(), frame:GetHeight();
		local w1,h1 = w,h;
		local a,b = frame:GetCenter();
		local duration, direction = ...;
		local duration = abs(tonumber(duration) or 1);
		local direction = (direction or ""):upper();
		local x,y=0,0
		if duration < jiffy then duration = jiffy end
		if ( direction == "HORIZONTAL" or direction == "HORISONTAL" ) then
			x = w; w = 0;
		else
			y = h; h = 0;
		end
		local elapsed = 0;
		tinsert(LibTransition.tQueue[frame], {args={a, b, "CENTER",1, w, h}, executeTime=now});
		while duration > elapsed do
			tinsert(LibTransition.tQueue[frame], {args={a, b, "CENTER",nil, w+(x*(elapsed/duration)), h+(y*(elapsed/duration))}, executeTime=now});
			now = now + jiffy;
			elapsed = elapsed + jiffy
		end
		tinsert(LibTransition.tQueue[frame], {args={a, b, "CENTER",1, w1, h1}, executeTime=now + jiffy});
	end
	if ( method ~= "WAIT" ) then frame:Show(); end
	return now;
end

function LibTransition:Run(frame)
	if LibTransition.cQueue[frame] then
		LibTransition.tQueue[frame] = LibTransition.tQueue[frame] or {};
		LibTransition.tQueue[frame].running = true;
	end
end

function LibTransition:Attach(frame)
	frame = self:GetFrame(frame);
	frame._LibTransition = self;
	for name, func in pairs(self) do
		local xfunc = name:match("Shorthand_(.*)");
		if xfunc then frame[xfunc] = func; end
	end
end

function LibTransition:Shorthand_FadeIn(...) self._LibTransition:Queue(self, "FadeIn", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_FadeOut(...) self._LibTransition:Queue(self, "FadeOut", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_Cut(...) self._LibTransition:Queue(self, "Cut", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_WipeDown(...) self._LibTransition:Queue(self, "WipeDown", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_WipeUp(...) self._LibTransition:Queue(self, "WipeUp", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_BoxIn(...) self._LibTransition:Queue(self, "BoxIn", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_BoxOut(...) self._LibTransition:Queue(self, "BoxOut", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_Materialize(...) self._LibTransition:Queue(self, "Materialize", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_Dissolve(...) self._LibTransition:Queue(self, "Dissolve", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_Squeeze(...) self._LibTransition:Queue(self, "Squeeze", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_Stretch(...) self._LibTransition:Queue(self, "Stretch", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_PushIn(...) self._LibTransition:Queue(self, "PushIn", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_PushOut(...) self._LibTransition:Queue(self, "PushOut", ...) self._LibTransition:Run(self) end
function LibTransition:Shorthand_Cover(...) self._LibTransition:Queue(self, "Cover", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_Random(...) self._LibTransition:Queue(self, "Random", ...) self._LibTransition:Run(self) end
function LibTransition:Shorthand_Fly(...) self._LibTransition:Queue(self, "Fly", ...) self._LibTransition:Run(self)end
function LibTransition:Shorthand_Drop(...) self._LibTransition:Queue(self, "Drop", ...) self._LibTransition:Run(self) end
function LibTransition:Shorthand_Bungee(...) self._LibTransition:Queue(self, "Bungee", ...) self._LibTransition:Run(self) end
function LibTransition:Shorthand_Wait(...) self._LibTransition:Queue(self, "Wait", ...) self._LibTransition:Run(self) end

function libt_test()
	for n = 0, 0 do
		local frame = CreateFrame("Frame", UIParent); -- make some frames
		frame:SetPoint("CENTER",0,300);
		frame:SetWidth(200);
		frame:SetHeight(100);
		local tex = frame:CreateTexture("ARTWORK");
		tex:SetAllPoints(frame);
		tex:SetTexture([[Interface\GLUES\Common\Glues-Logo]]);
		LibTransition:Attach(frame);
		frame:Hide();
		frame:Wait(n); -- queue their animations to start at different times
		frame:PushIn("LEFT", 0.75);	-- push the frames in from the right
		frame:FadeOut(1, 0.5); -- fade them out a bit
		frame:FadeIn(1); -- fade back in
		frame:Wait(1); -- wait 1 second
		frame:Drop(true); -- drop them and bounce, bounce, bounce!
		frame:PushOut("RIGHT", 2); -- push them out to the right side.
		--frame:Squeeze(1, "HORISONTAL");
	end
end

LibTransition.timer = CreateFrame("Frame", UIParent);
LibTransition.timer:SetPoint("BOTTOMRIGHT", 0, 0);
LibTransition.timer:SetWidth(1);
LibTransition.timer:SetHeight(1);
LibTransition.timer:SetScript("OnUpdate", LibTransition.runTimer);
