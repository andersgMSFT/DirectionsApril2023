tableextension 52001 PowerAppsItem extends Item
{
    fields
    {
        field(51000; Height; Decimal)
        {
            Caption = 'Height';
            DataClassification = CustomerContent;
        }
        field(51001; width; Decimal)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
        }
        field(51002; Depth; Decimal)
        {
            Caption = 'Depth';
            DataClassification = CustomerContent;
        }
        field(51003; IsAvialableForFieldWorker; Boolean)
        {
            Caption = 'Is Avialable For Field Worker';
            DataClassification = CustomerContent;
        }
    }
}