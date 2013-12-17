if object_id('SplitByString') is not null
	drop function SplitByString
go

create function SplitByString(
	@s varchar(max)
,	@d varchar(10)
)
returns @ret table (
	i int identity, s varchar(128)
)
as
	begin
	/*
	**	- Synopsis -
	**	Splits a string delimited by a delimiter
	**	and returns a table with its tokens
	**
	**	- Syntax -
	**	@s: string that is to be split into a table
	**	@d: the delimiter the segments the string
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	SET @s = ltrim(rtrim(@s)) + @d
	if replace(@s, @d, '') = ''
		return

	declare	@i int
	,	@token	varchar(128)

	set @i = charindex(@d, @s, 1)
	while @i > 0
		begin
		select @token = ltrim(rtrim(left(@s, @i - 1)))
		if @token != ''	insert @ret select @token

		set @s = right(@s, len(@s) - @i - (len(@d) - 1))
		set @i = charindex(@d, @s, len(@d))
		end
	return
	end

-- exempli gratia ------------------------------------------------------------

/*
	select * from SplitByString('this that', '/')
	select * from SplitByString('this--that', '--')
	select * from SplitByString('this/that/', '/')
*/
