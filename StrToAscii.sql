if object_id('StrToAscii') is not null
	drop function StrToAscii
go
create function StrToAscii(@s varchar(max))
returns varchar(max)
as
	begin
	/*
	**	- Synopsis -
	**	Returns a sring consisting of the characters
	**	and their ordinal values in the string passed in
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	declare	@i int = 1
	,	@ret varchar(max) = ''

	while @i <= len(@s)
		begin
		select @ret = @ret
		+ substring(@s, @i, 1)
		+ '=' + convert(varchar, ascii(substring(@s, @i, 1)))
		+ ' '
		select @i = @i + 1
		end

	return @ret
	end
go

-- exempli gratia -------------------------------------------------------------

/*
	select dbo.StrToAscii('sample text')
*/
