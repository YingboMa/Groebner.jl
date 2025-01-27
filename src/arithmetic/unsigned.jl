
#= Finite field aritmhetic implemented in unsigned integers =#
#= It is generally faster than AbstractAlgebra.GF interface =#

# returns x - y*a modulo ch
@inline function umultsubmod(
        x::T, y::T, a::T, ch::T) where {T<:Unsigned}
    ya = y*a % ch
    (x + ch - ya) % ch
end

# returns x + y*a modulo ch
@inline function umultsummod(
        x::T, y::T, a::T, ch::T) where {T<:Unsigned}
    ya = y*a % ch   # TODO: omit % ch
    (x + ya) % ch
end

# returns x⁻¹ modulo ch
@inline function uinvmod(x::T, ch::T) where {T<:Unsigned}
    # seems like we dont need % ch
    invmod(x, ch) % ch
end

# returns -x modulo ch
@inline function ucompmod(x::T, ch::T) where {T<:Unsigned}
    ch - x
end

# returns x*y modulo ch
@inline function umultmod(x::T, y::T, ch::T) where {T<:Unsigned}
    (x*y) % ch
end

# returns x + y modulo ch
@inline function usummod(x::T, y::T, ch::T) where {T<:Unsigned}
    (x + y) % ch
end
