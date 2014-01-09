if object_id('SplitByString') is not null
	drop function SplitByString
go

create function SplitByString(
	@s nvarchar(max)
,	@d nvarchar(10)
)
returns @ret table (
	i int identity, s nvarchar(max)
)
as
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

	begin        
	declare @i int = 1
	while 1 = 1
		begin
		declare @j int = charindex(@d, @s, @i + 1)
		if @j = 0 break
		insert @ret select substring(@s, @i, @j - @i)
		set @i = @j + len(@d)
		end
	insert @ret select substring(@s, @i, len(@s))
	return        
	end

-- exempli gratia ------------------------------------------------------------

/*
	select * from SplitByString('this that', '/')
	select * from SplitByString('this--that', '--')
	select * from SplitByString('this/that/', '/')
*/

-- performance ---------------------------------------------------------------

/*
This function pays a certain cost for the use of nvarchars (4%) and the
inclusion of the identity column in the output table (15%).  applications
that care about better performance may remove these features for the
aforementioned gains

The code below can be used to generate performance metrics for @n number
of tokens in a string, where each token is @len characters in length.

declare @n int = 10000
,		@len int = 100
declare @s varchar(max) = ''
while @n > 1
	begin
	set @s = @s + replicate('x', @len) + ','
	set @n = @n - 1
	end
set @s = @s + replicate('x', @len)

declare @t1 as table (s varchar(max))
set @dt = getdate()
insert @t1 select s from SplitByString(@s)
print datediff(ms, @dt, getdate())
*/
