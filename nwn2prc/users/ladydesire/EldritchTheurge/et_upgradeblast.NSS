// Draco Rayne 29/09/2007: Eldritch Blast progression with Eldritch Theurge levels

#include "nw_i0_invocatns"
	
void main()
{
	int nBlstLvl;
	int ClassTotal = GetLevelByClass(CLASS_TYPE_WARLOCK) + GetLevelByClass(CLASS_TYPE_ELDRITCHTHEURGE);
	if (ClassTotal<=11) nBlstLvl=(ClassTotal+1)/2;
	else if (ClassTotal<=20) nBlstLvl= 6 + (ClassTotal-11)/3;
	else nBlstLvl= 9 + (ClassTotal-20)/2;
	SendMessageToPC(OBJECT_SELF,"Blast upgrade check");
	
	if ((nBlstLvl==14)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_14)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_14, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_13);
	}
	else if ((nBlstLvl==13)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_13)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_13, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_13);
	}
	else if ((nBlstLvl==12)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_12)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_12, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_11);
	}
	else if ((nBlstLvl==11)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_11)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_11, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_10);
	}
	else if ((nBlstLvl==10)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_10)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_10, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_9);
	}
	else if ((nBlstLvl==9)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_9)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_9, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_8);
	}
	else if ((nBlstLvl==8)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_8)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_8, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_7);
	}
	else if ((nBlstLvl==7)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_7)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_7, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_6);
	}
	else if ((nBlstLvl==6)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_6)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_6, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_5);
	}
	else if ((nBlstLvl==5)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_5)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_5, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_4);
	}
	else if ((nBlstLvl==4)&&(GetHasFeat(FEAT_ELDRITCH_BLAST_4)==FALSE))
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_4, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_3);
	}
	else
	{
		FeatAdd(OBJECT_SELF, FEAT_ELDRITCH_BLAST_3, TRUE);
		FeatRemove(OBJECT_SELF, FEAT_ELDRITCH_BLAST_2);
	}
}