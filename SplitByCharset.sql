if object_id('SplitByCharset') is not null
	drop function SplitByCharset
go

create function SplitByCharset(@s varchar(max), @charset varchar(32))
returns @ret table (
	i int identity, s varchar(128)
	)
as
	begin
	/*
	**	- Synopsis -
	**	Splits a string by any of the characters in a given set,
	**	returning a table with its tokens.  Please note that the
	**	delimiters are swallowed.  Also, empty records are not
	**	returned.
	**
	**	- Syntax -
	**	@s: String to be split
	**	@charset: a string containing characters on which to split
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	declare @i int = 0
	while @i <= len(@s)
		begin
		select  @i = @i + 1
		if charindex(substring(@s, @i, 1), @charset) > 0
			begin
			if left(@s, @i - 1) != ''
				insert @ret
				select ltrim(rtrim(left(@s, @i - 1)))
			set @s = substring(@s, @i + 1, len(@s))
			set @i = 0
			end
		end

	insert @ret select @s
	return
	end

go

-- exempli gratia ----------------------------------------------

/*
	select * from SplitByCharset('+1+2-3', '+-')
	select * from SplitByCharset('+1 +2 -3', '+-')
*/
