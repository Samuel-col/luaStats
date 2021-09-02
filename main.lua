-----------------
-- ESTADÍSTICA --
-----------------

--[[
Este módulo contiene las siguientes funciones:

Estadística Descriptiva:
 * sum
 * mean
 * isIn
 * unique
 * show
 * simpSort
 * isEven
 * unKey
 * min
 * max
 * median
 * count
 * freq
 * moda
 * boolN
 * quant 
~* var
 * sd
 * SymCoef
 * curt
Probabilidad:
 * dist
 * E
 * Var
 * pdf
 * mgf
 * rand
Inferencia Estadística:
 * IC mean
 * IC var
 * t test
Análisis de Regresión:
 * Regresión Lineal Múltiple
 * Modelos de rango incompleto

--]]

mat = require"matrix"

local stats = {}


-- Arrays de prueba
a = {1,2,3,4,2}

b = {7,8,9,10,10,4}


function stats.sum(arr) -- suma
		local s = 0
		for k,v in pairs(arr) do
				s = s + v
		end
		return s
end


function stats.mean(arr) -- media

		return stats.sum(arr)/(#arr)
end


function stats.isIn(num,arr) -- contenencia

		local a = false
		for k,v in pairs(arr) do
				if (num==v) then
						a = true
						break
				end
		end

		return a
end


function stats.isNumber(x) -- check number
		if tonumber(x)~= nil then
				return true
		else
				return false
		end
end


function stats.unique(arr) --únicos

		local u = {}
		local ind = 1
		for k,v in pairs(arr) do
				if (not stats.isIn(v,u)) then
						u[ind] = v
						ind = ind + 1
				end
		end

		return u
end


function stats.show(arr) --imprimir

		if tonumber(arr)~=nil then
				print(arr)
		else
				for k,v in pairs(arr) do
						io.write(k,"\t\t",v,"\n")
				end
		end
end


function stats.simpSort(arr,n1,n2) -- orden 2 a 2
		
		if (arr[n1]>arr[n2]) then
				local t = arr[n1]
				arr[n1] = arr[n2]
				arr[n2] = t
		end

end


function stats.isEven(num) -- es par

		local a = false
		if (math.ceil(num/2)==num/2) then
				a = not a
		end

		return a
end


function stats.unKey(arr) -- Quitar llaves
		local ans = {}
		for k,v in pairs(arr) do
				table.insert(ans,v)
		end

		return ans
end


function stats.median(arr) -- mediana

		local ans =stats.unKey(arr)
		table.sort(ans)
		if stats.isEven(#ans) then
				return stats.mean({ans[#ans/2],ans[#ans/2+1]})
		else
				return ans[#ans/2+0.5]
		end

end


function stats.max(arr) -- max

		return math.max(table.unpack(arr))
end


function stats.min(arr) --min

		return math.min(table.unpack(arr))
end


function stats.count(num,arr) -- coincidencias

		local t = 0
		for k,v in pairs(arr) do
				if (v==num) then 
						t = t + 1
				end
		end

		return t
end


function stats.freq(arr) -- frecuencias

		local rep = {}
		for k,v in pairs(stats.unique(arr)) do
				rep[v] = stats.count(v,arr)
		end

		return rep
end


function stats.moda(arr) -- modas

		local m = stats.max(st.unKey(st.freq(arr)))
		local modas = {}
		for k,v in pairs(stats.freq(arr)) do
				if (v==m) then
						table.insert(modas,k)
				end
		end

		if #modas==1 then
				return modas[1]
		else
				return modas
		end
end


function stats.boolN(v) -- usar bools
		if v then
				return 1
		else
				return 0
		end
end


function stats.round(x) -- redondear
		return math.floor(x)*stats.boolN(x-math.floor(x)<=0.5) + math.ceil(x)*stats.boolN(x-math.floor(x)>0.5)
end


function stats.quant(arr,qs) -- quantil

		local tmp = stats.unKey(arr)
		table.sort(tmp)
		local quant = {}
		for _,v in pairs(qs) do
				if stats.isIn(v,{0,1}) then
						quant[v] = v*stats.max(tmp)+(1-v)*stats.min(tmp)
				elseif ( v*#tmp < 1 ) then
						quant[v] = stats.min(tmp)
				elseif ( v*#tmp + 1 > #tmp ) then
						quant[v] = stats.max(tmp)
				elseif ( v*#tmp==math.ceil(v*#tmp)	) then
						quant[v] = (tmp[v*#tmp]+tmp[v*#tmp+1])/2
				else
						quant[v] = (tmp[math.ceil(v*#tmp)]*(v*#tmp-math.floor(v*#tmp)))-(tmp[math.floor(v*#tmp)]*(v*#tmp-math.ceil(v*#tmp)))
				end
		end
		table.sort(quant)

		return quant
end


stats.var = {}

function stats.var.p(arr) -- Varinza poblacional
		
		local m = stats.mean(arr)
		local mJ = {}
		for i=1,#arr do
				mJ[i] = 1
		end
		local cent = mat(arr)-mat(mJ)

		return (cent^'T'*cent)/#arr

end

function stats.var.m(arr) -- varianza muestral
		
		local m = stats.mean(arr)
		local mJ = {}
		for i=1,#arr do
				mJ[i] = 1
		end
		local cent = mat(stats.unKey(arr))-mat(mJ)

		return (cent^'T'*cent)/(#arr-1)

end


stats.sd = {}

function stats.sd.p(arr) -- desviación estándar poblacional

		return math.sqrt(stats.var.p(arr))
end


function stats.sd.m(arr) -- desviación estándar poblacional

		return math.sqrt(stats.var.m(arr))
end


function stats.moment(arr,k) -- momentos muestrales
	
		local m = stats.mean(arr)
		local s = 0
		local tmp = stats.unKey(arr)
		
		for i=1,#arr do
				s = s + (tmp[i]-m)^k
		end

		return s/(#arr-1)
end


stats.SymCoef = {}

stats.SymCoef.Fisher = {}

function stats.SymCoef.Fisher.m(arr) -- Coeficiente de asimetría de Fisher

		return stats.moment(arr,3)/(stats.var.m(arr))^1.5

end


stats.SymCoef.Pearson = {}

function stats.SymCoef.Pearson.m(arr) -- Coeficiente de asimetría de Pearson
		
		return (stats.mean(arr)-stats.moda(arr))/stats.sd.m(arr)
end


stats.curt = {}

function stats.curt.m(arr)

		return stats.moment(arr,4)/(stats.var.m(arr))^2-3
end


function stats.explore(arr)

		local res = {}
		local cuantiles = stats.quant(arr,{0.1,0.25,0.75,0.9})

		res["min"] = stats.min(arr)
		res["q 0.1"] = cuantiles[0.1]
		res["q 0.25"] = cuantiles[0.25]
		res["median"] = stats.median(arr)
		res["mean"] = stats.mean(arr)
		res["moda"] = stats.moda(arr)
		res["q 0.75"] = cuantiles[0.75]
		res["q 0.9"] = cuantiles[0.9]
		res["max"] = stats.max(arr)
		-- res["var"] = stats.var.m(arr)
		-- res["sd"] = stats.sd.m(arr)
		-- res["sym"] = stats.SymCoef.Fisher.m(arr)
		-- res["curt"] = stats.curt.m(arr)

		io.write("min",res["min"])
		io.write("q 0.1",res["q 0.1"])
		io.write("q 0.25",res["q 0.25"])
		io.write("mean",res["mean"])
		io.write("median",res["median"])
		io.write("moda",res["moda"])
		io.write("q 0.75",res["q 0.75"])
		io.write("q 0.9",res["q 0.9"])
		io.write("max",res["max"])
		-- io.write("var",res["var"])
		-- io.write("sd",res["sd"])
		-- io.write("sym",res["sym"])
		-- io.write("curt",res["curt"])

		return res
end


return stats
