if object_id('StrNumeric') is not null
	drop function StrNumeric
go

create function dbo.udfStrToNumeric (@s varchar(32))
returns float
as
	/*
	**	- Synopsis -
	**	This function strips non-numeric characters from
	**	a string allowing for conversion of percetages ("40.2%")
	**	spreads ("L+50") and other such variations
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	begin
	declare	@i int = 1
	,	@ret varchar(32) = ''
	,	@c char(1)

	while @i <= len(@s)
		begin
		select @c = substring(@s, @i, 1)
		select @ret = @ret + @c
		where IsNumeric(@c) = 1 OR @c IN ('-', '.')

		select @i = @i + 1
		end

	return convert(float, @ret)
	end
go

-- exempli gratia -------------------------------------------------------------

/*
	select 'X-30.2', dbo.StrToNumeric('X-30.2')
	select '45.2%', dbo.StrToNumeric('45.2%')
	select 'L+300', dbo.StrToNumeric('L+300')
*/
