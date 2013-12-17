if object_id('StrTokenNbr') is not null
	drop function StrTokenNbr
go

create function StrTokenNbr(
	@s varchar(max), @tok varchar(max), @dc char(1)
	)
returns int
as
	/*
	**	- Synopsis -
	**	Returns the position of @tok within a @dc separated string @s
	**	If the last token in @s is an asterisk, @tok will match it,
	**	returning its position.  This is useful for doing /else/ type
	**	matches when sorting e.g.
	**		ORDER BY dbo.udfStrTokenNbr('bid,mean,ask', code, ',')
	**	cf. udfSecurityYTW() for use
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	begin
	declare	@x table (i int, s varchar(max))
	insert	@x select i, s from SplitByString(@s, @dc)

	declare	@ret int
	select @ret = i from @x where s = @tok
	if @ret is null and right(@s, 1) = '*'
		select @ret = count(*) from @x

	return @ret
	end
go

-- exempli gratia -------------------------------------------------------------

/*
	select dbo.StrTokenNbr('besser|spaet|als|nie', 'als', '|')
	select dbo.StrTokenNbr('besser|spaet|als|nie', 'nix', '|')
	select dbo.StrTokenNbr('besser|spaet|als|nie|*', 'nix', '|')
*/
