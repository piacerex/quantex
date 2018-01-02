defmodule Q do
	@moduledoc """
	Documentation for Q ( Elixir Quantum module ).
	"""

	require Math

	@doc """
	|0> qubit ... ( 1, 0 )
	"""
	def q0(), do: Numexy.new( [ 1, 0 ] )

	@doc """
	|1> qubit ... ( 0, 1 )
	"""
	def q1(), do: Numexy.new( [ 0, 1 ] )

	@doc """
	1 / sqrt( 2 )
	"""
	def n07(), do: 1 / Math.sqrt( 2 )

	@doc """
	To bit from number, number list or number matrix.
	"""
	def to_bit(  0.9999999999999998 ), do:  1
	def to_bit( -0.9999999999999998 ), do: -1
	def to_bit(  0.0 ), do: 0
	def to_bit( value ) when is_list( value ) do
		case value |> List.first |> is_list do
			true  -> value |> Enum.map( &( &1 |> Enum.map( fn y -> to_bit( y ) end ) ) )
			false -> value |> Enum.map( &( to_bit( &1 ) ) )
		end
	end
	def to_bit( %Array{ array: list, shape: _ } ), do: list |> to_bit |> Numexy.new
	def to_bit( value ), do: value

	@doc """
	X gate.
	"""
	def x( qubit ), do: Numexy.dot( xx(), qubit )
	@doc """
	for X gate 2x2 matrix ... ( ( 0, 1 ), ( 1, 0 ) )
	"""
	def xx(), do: Numexy.new [ [ 0, 1 ], [ 1, 0 ] ]

	@doc """
	Z gate.
	"""
	def z( %Array{ array: _list, shape: { 2, nil } } = qubit ), do: Numexy.dot( z2x(), qubit )
	def z( %Array{ array: _list, shape: { 4, nil } } = qubit ), do: Numexy.dot( z4x(), qubit )
	@doc """
	for Z gate 2x2 matrix ... ( ( 0, 1 ), ( 1, 0 ) )
	"""
	def z2x() do
		Numexy.new [ 
			[ 1, 0 ], 
			[ 0, -1 ]
		]
	end
	@doc """
	for Z gate 4x4 matrix ... ( ( 1, 0, 0, 0 ), ( 0, 1, 0, 0 ), ( 0, 0, 1, 0 ), ( 0, 0, 0, -1 ) )
	"""
	def z4x() do
		Numexy.new [ 
			[ 1, 0, 0,  0 ], 
			[ 0, 1, 0,  0 ], 
			[ 0, 0, 1,  0 ], 
			[ 0, 0, 0, -1 ], 
		]
	end

	@doc """
	Hadamard gate.
	"""
	def h( qubit ), do: Numexy.mul( hx(), 1 / Math.sqrt( 2 ) ) |> Numexy.dot( qubit ) |> to_bit
	@doc """
	for Hadamard gate matrix ... ( ( 1, 1 ), ( 1, -1 ) )
	"""
	def hx(), do: Numexy.new [ [ 1, 1 ], [ 1, -1 ] ]
end
