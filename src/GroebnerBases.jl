
module GroebnerBases

import AbstractAlgebra
import AbstractAlgebra.Generic: MPoly, GFElem
import AbstractAlgebra: leading_term, QQ, PolynomialRing, terms,
                        coeff, divides, base_ring, elem_type,
                        rref, isconstant, leading_coefficient,
                        map_coefficients, monomials, degree,
                        degrees, isconstant, leading_monomial,
                        GF, gens, MatrixSpace, coefficients,
                        crt, ordering, exponent_vectors, lift,
                        MPolyBuildCtx, finish, push_term!, ZZ,
                        content, change_base_ring, exponent_vector,
                        lcm, monomial, RingElem, set_exponent_vector!,
                        MPolyRing, nvars


# hmm??
# We do not want this
import Nemo

import Combinatorics
import Primes
import Primes: nextprime
import SparseArrays: SparseVector, findnz, nnz

import DataStructures: SortedSet

import UnicodePlots
import Logging

# SparseVector from SparseArrays modified to work with AA
include("add_ons_to_sa/sparsevectoraa.jl")

include("utils.jl")

# Modular computations: reduction and reconstrction of coefficients
include("modular.jl")

#
include("add_ons_to_aa/monomial_ops.jl")
include("add_ons_to_aa/poly_conversions.jl")

include("common.jl")


# generating sets of test polynomials
include("testgens.jl")

# f4 implementation over finite fields
include("f4.jl")

# fglm implementation over finite fields
include("fglm.jl")

# everything above is composed here
include("algorithm.jl")


export f4, fglm
export rootn
export groebner
export is_groebner

end
