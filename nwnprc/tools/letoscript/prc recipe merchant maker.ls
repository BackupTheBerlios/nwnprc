%store = 'C:\Games\NeverwinterNights\NWN\modules\temp0\prc_wiz_recipe.utm' or die $!;
meta dir=> 'C:\Documents and Settings\user\Desktop\PRC Stuff\prc\Craft2das' or die $!;
$i = 0;
$max = 753;
$x = 0;
$y = 0;

add Name => /StoreList/[2]/ItemList, Type=>gffList;


for($i=0; $i<=$max; $i++)
{
	$resref = lookup 'item_to_ireq', $i, 'RECIPE_TAG';
	add Name => /StoreList/[2]/ItemList/InventoryRes, Type => gffResRef, Value => $resref;
	add Name => /StoreList/[2]/ItemList/[_]/Infinite, Type => gffByte, Value => 1;
	add Name => /StoreList/[2]/ItemList/[_]/Repos_PosX, Type => gffByte, Value => $x;
	add Name => /StoreList/[2]/ItemList/[_]/Repos_Posy, Type => gffByte, Value => $y;
	$x++;
	if($x>9)
	{
		$x = 0;
		$y++;
	}
	print "$resref $x $y \n";
}

%store = '>';