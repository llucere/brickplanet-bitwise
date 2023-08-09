-- this script was made 8/9/2023, before brickplanet had an intellisense or bitwise
-- bryan kearney @bryan8038 on YouTube
-- made on brickplanet for brickplanet when data storage comes out some day

--------#### API ####--------
--# bit64.highestPow2(x)
---- gets the highest power of 2 in a number

--# bit64.band2(bitstream1, bitstream2)
---- 2 input and gate- shared 1s are returned

--# bit64.bnand2(bitstream1, bitstream2)
---- 2 input and gate- shared 1s are turned into 0s

--# bit64.bor2(bitstream1, bitstream2)
---- 2 input and gate- all 1s are returned

--# bit64.bnor2(bitstream1, bitstream2)
---- 2 input and gate- returns shared 0s as 1s

--# bit64.bnot(bitstream1)
---- inverses all the 1s and 0s, up to the last 1 or 0

--# bit64.stringToBinary(unconverted) @ bit64.stringToDecimal(unconverted)
---- turns string into binary

--# bit64.binaryToString(unconverted) @ bit64.decimalToString(unconverted)
---- turns binary into string

--# bit64.replace(target, datum, numBits, shift)
---- replace mask of 'numBits' with lshift 'shift' inside target, with datum

--# bit64.extract(target, numBits, shift)
---- extracts mask of 'numBits' with lshift 'shift' inside target

--# bit64.mask(numBits, shift)
---- creates a mask with length 'numBits' shifted to the left by 'shift'

--# bit64.maskNoShift(numBits)
---- creates a mask with length 'numBits'

--# bit64.lshift(bitstream, n)
---- shifts bitstream over to the left n times

--# bit64.rshift(bitstream, n)
---- shifts bitstream over to the left n times
--------#### END OF API ####--------

local bit64 = {}

-- x % 4 = x & 3
-- MOD(b, n) is equivalent to AND(b, n - 1)

function bit64.highestPow2(x)
	return math.modf(math.log(x, 2))
end

local function getBit(x, n)
	return x % (n + 1)
end

function bit64.band2(bitstream1, bitstream2)
	local highPow2 = 2^math.max(bit64.highestPow2(bitstream1), bit64.highestPow2(bitstream2))
	local sum = 0
	local n = 1
	
	while (n <= highPow2) do
		if (getBit(bitstream1, 1) == 1 and getBit(bitstream2, 1) == 1) then
			sum = sum + n
		end

		bitstream1 = math.modf(bitstream1 / 2)
		bitstream2 = math.modf(bitstream2 / 2)
		n = n * 2
	end
	return sum
end

function bit64.bnand2(bitstream1, bitstream2)
	local highPow2 = 2^math.max(bit64.highestPow2(bitstream1), bit64.highestPow2(bitstream2))
	local sum = 0
	local n = 1
	
	while (n <= highPow2) do
		if (not (getBit(bitstream1, 1) == 1 and getBit(bitstream2, 1) == 1)) then
			sum = sum + n
		end

		bitstream1 = math.modf(bitstream1 / 2)
		bitstream2 = math.modf(bitstream2 / 2)
		n = n * 2
	end
	return sum
end

function bit64.bor2(bitstream1, bitstream2)
	local highPow2 = 2^math.max(bit64.highestPow2(bitstream1), bit64.highestPow2(bitstream2))
	local sum = 0
	local n = 1
	
	while (n <= highPow2) do
		if (getBit(bitstream1, 1) == 1 or getBit(bitstream2, 1) == 1) then
			sum = sum + n
		end

		bitstream1 = math.modf(bitstream1 / 2)
		bitstream2 = math.modf(bitstream2 / 2)
		n = n * 2
	end
	return sum
end

function bit64.bnor2(bitstream1, bitstream2)
	local highPow2 = 2^math.max(bit64.highestPow2(bitstream1), bit64.highestPow2(bitstream2))
	local sum = 0
	local n = 1
	
	while (n <= highPow2) do
		if (not (getBit(bitstream1, 1) == 1 or getBit(bitstream2, 1) == 1)) then
			sum = sum + n
		end

		bitstream1 = math.modf(bitstream1 / 2)
		bitstream2 = math.modf(bitstream2 / 2)
		n = n * 2
	end
	return sum
end

function bit64.bnot(bitstream1)
	local highPow2 = 2^bit64.highestPow2(bitstream1)
	local sum = 0
	local n = 1
	
	while (n <= highPow2) do
		if (not getBit(bitstream1, 1)) then
			sum = sum + n
		end

		bitstream1 = math.modf(bitstream1 / 2)
		bitstream2 = math.modf(bitstream2 / 2)
		n = n * 2
	end
	return sum
end

function bit64.stringToBinary(unconverted)
	local len = string.len(unconverted)
	local sum = 0
	for i = len, 1, -1 do
		local charIndex = len-i+1
		if (string.sub(unconverted, charIndex, charIndex) == "1") then
			sum = sum + math.pow(2, i - 1)
		end
	end
	return sum
end
bit64.stringToDecimal = bit64.stringToBinary

function bit64.binaryToString(decimal, addNotation)
	local highPow2 = 2^bit64.highestPow2(decimal)
	local bitstream = ""
	local n = 1
	
	while (n <= highPow2) do
		if (getBit(decimal, 1) == 1) then
			bitstream = "1"..bitstream
		else
			bitstream = "0"..bitstream
		end

		decimal = math.modf(decimal / 2)
		n = n * 2
	end

	return (addNotation and ("0b") or (""))..bitstream
end
bit64.decimalToString = bit64.binaryToString

function bit64.lshift(bitstream, n)
	local shift = math.modf(bitstream * math.pow(2, n))
	return shift
end

function bit64.rshift(bitstream, n)
	local shift = math.modf(bitstream / math.pow(2, n))
	return shift 
end

function bit64.maskNoShift(numBits)
	return (math.pow(2, numBits) - 1)
end

function bit64.mask(numBits, shift) 
	return bit64.lshift(bit64.maskNoShift(numBits), shift)
end

function bit64.extract(target, numBits, shift)
	return bit64.rshift(bit64.band2(target, bit64.mask(numBits, shift)), shift)
end

function bit64.replace(target, datum, numBits, shift)
	local newDatum = bit64.lshift(bit64.band2(datum, bit64.maskNoShift(numBits)), shift)
	local clrMask = bit64.bnot(bit64.maskNoShift(numBits))
	return bit64.bor2(bit64.band2(target, clrMask), newDatum)
end

return bit64