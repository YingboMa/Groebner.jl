
# sorts generators and corresponding coefficients from basis
# by their leading monomial in increasing ordering
#
# Used only once to sort input generators
function sort_gens_by_lead_increasing!(basis::Basis, ht::MonomialHashtable)
    gens = basis.gens
    exps = ht.exponents

    inds = collect(1:basis.ntotal)
    cmp  = (x, y) -> exponent_isless(exps[gens[x][1]], exps[gens[y][1]])
    sort!(inds, lt=cmp)

    # use array assignment insted of elemewise assignment
    # Reason: slice array assignment uses fast setindex! based on unsafe copy
    basis.gens[1:basis.ntotal]   = basis.gens[inds]
    basis.coeffs[1:basis.ntotal] = basis.coeffs[inds]
end

#------------------------------------------------------------------------------

# Sorts pairs from pairset in range [from, from+size]
# by lcm degrees in increasing order
#
# Used only once per one f4 iteration to sort pairs in pairset
function sort_pairset_by_degree!(ps::Pairset, from::Int, sz::Int)
    #= WARNING: BUG =#
    # sz is size !
    # the correct should be ps.pairs[from:from + sz]

    part = ps.pairs[from:from + sz]

    sort!(part, by=p -> p.deg)

    ps.pairs[from:from + sz] = part
end

#------------------------------------------------------------------------------

function sort_generators_by_position!(gens, load)
    # @info "Sorting first $load gens"
    part = gens[1:load]
    sort!(part)
    gens[1:load] .= part
    gens
end

function sort_pairset_by_lcm!(pairset, npairs, ht)
    part = pairset.pairs[1:npairs]
    sort!(part, lt=(x, y) -> exponent_isless(ht.exponents[x.lcm], ht.exponents[y.lcm]))
    pairset.pairs[1:npairs] .= part
    pairset
end

#------------------------------------------------------------------------------

#=
    :degrevlex exponent vector comparison
=#
function exponent_isless(ea, eb)
    if ea[end] < eb[end]
        return true
    elseif ea[end] != eb[end]
        return false
    end

    i = length(ea) - 1
    while i > 1 && ea[i] == eb[i]
        i -= 1
    end

    return ea[i] < eb[i] ? false : true
end

#------------------------------------------------------------------------------

function matrix_row_decreasing_cmp(a, b)
    #= a, b - rows as arrays of exponent hashes =#

    va = a[1]
    vb = b[1]

    if va > vb
        return false
    end
    if va < vb
        return true
    end

    # same column index => compare density of rows

    va = length(a)
    vb = length(b)
    if va > vb
        return false
    end
    if va < vb
        return true
    end

    # hmm, equal rows?
    return false
end

function matrix_row_increasing_cmp(a, b)
    #= a, b - rows as arrays of exponent hashes =#

    va = a[1]
    vb = b[1]

    if va > vb
        return false
    end
    if va < vb
        return true
    end

    # same column index => compare density of rows

    va = length(a)
    vb = length(b)
    if va > vb
        return false
    end
    if va < vb
        return true
    end

    # hmm, equal rows?
    return false
end

# by column index and density
function sort_matrix_rows_decreasing!(matrix)
    #= smaller means  pivot being more left  =#
    #= and density being smaller             =#

    # @info "before up sort"
    #println(matrix.uprows)
    #println(matrix.up2coef)

    inds = collect(1:matrix.nup)
    cmp  = (x, y) ->  matrix_row_decreasing_cmp(matrix.uprows[x], matrix.uprows[y])
    sort!(inds, lt=cmp)

    matrix.uprows[1:matrix.nup] .= matrix.uprows[1:matrix.nup][inds]
    matrix.up2coef[1:matrix.nup] .= matrix.up2coef[1:matrix.nup][inds]

    # @info "after up sort"
    #println(matrix.uprows)
    #println(matrix.up2coef)

    matrix
end

# by column index and density
function sort_matrix_rows_increasing!(matrix)
    #= smaller means  pivot being more right =#
    #= and density being larger =#

    # @info "before low sort"
    #println(matrix.lowrows)
    #println(matrix.low2coef)

    inds = collect(1:matrix.nlow)
    cmp  = (x, y) ->  matrix_row_increasing_cmp(matrix.lowrows[x], matrix.lowrows[y])
    sort!(inds, lt=cmp)

    matrix.lowrows[1:matrix.nlow] .= matrix.lowrows[1:matrix.nlow][inds]
    matrix.low2coef[1:matrix.nlow] .= matrix.low2coef[1:matrix.nlow][inds]

    # @info "after low sort"
    #println(matrix.lowrows)
    #println(matrix.low2coef)

    matrix
end

function sort_gens_terms_decreasing!(basis, ht, i)
    inds = collect(1:length(basis.gens[i]))
    gen = basis.gens[i]
    cmp  = (x, y) -> exponent_isless(ht.exponents[gen[x]], ht.exponents[gen[y]])
    sort!(inds, lt=cmp)
    basis.gens[i] = basis.gens[i][inds]
    basis.coeffs[i] = basis.coeffs[i][inds]
    basis
end

function sort_columns_by_hash!(col2hash, symbol_ht)
    hd = symbol_ht.hashdata
    es = symbol_ht.exponents
    len = symbol_ht.explen

    function cmp(a, b)
        ha = hd[a]
        hb = hd[b]

        if ha.idx != hb.idx
            return ha.idx > hb.idx
        end

        ea = es[a]
        eb = es[b]
        !exponent_isless(ea, eb)
    end

    sort!(col2hash, lt = cmp)
end
