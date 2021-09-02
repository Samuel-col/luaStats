------------------
-- PROBABILIDAD --
------------------

--[[
Este módulo contiene las siguientes funciones:

 * dist
 * E
 * Var
 * pdf
 * mgf
 * rand

--]]

local prob = {}

st = require"stats"

prob.dist = {}


function prob.dist.unif(a,b) -- distribución uniforme contínua
		
		local X = {}

		X.ty = "ProbDist"

		X.par = {a or 0,b or 1}

		function X.pdf(x)
		
				return boolN(x>=X.par.a and x<=X.par.b)/(X.par.b-X.par.a)
		end

		X.pobPar = {}

		X.pobPar.E = (X.par.a+X.par.b)/2

		X.pobPar.V = (X.par.b-X.par.a)^2/12

		X.pobPar.CV = math.sqrt(X.pobPar.V)/X.pobPar.E

		function X.rand(n)

				local res = {}

				for i=1,n do
						res[i] = (X.par.b-X.par.a)*math.random()+X.par.a
				end

				return res
		end

		return X
end


function prob.dist.unifD(n1,n2) -- distribución uniforme distreta

		local X = {}

		X.ty = "ProbDist"

		X.par = {n1 or 0, n2 or 10}

		function X.pdf(k)

				if k==math.ceil(k) and k>=X.par.n1 and k <=X.par.n2 then

						return 1/(X.par.n2-X.par.n1+1)
				else
						return 0
				end
		end

		X.pobPar = {}

		X.pobPar.E = (X.par.n2+X.par.n1)/2

		X.pobPar.V = ((X.par.n2-X.par.n1+1)^2-1)/12

		X.pobPar.CV = math.sqrt(X.pobPar.V)/X.pobPar.E

		function X.rand(n)

				local res = {}

				for i=1,n do
						res[i] = math.random(X.par.n1,X.par.n2)
				end

				return res
		end

		return X
end


return prob
