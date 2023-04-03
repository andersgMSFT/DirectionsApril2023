codeunit 52001 PowerAppsDemoDataGenerator
{
    procedure DeleteDemoDataForPowerApps()
    var
        itemRecord: Record Item;
        cutsomerRecord: Record Customer;
    begin
        // Delete all added items
        itemRecord.SetRange(IsAvialableForFieldWorker, true);
        itemRecord.DeleteAll(true);

        // Note: We are leaving the item catagories since they don't disturb much
    end;

    procedure GenerateDemoDataForPowerApps()
    begin
        GenerateDemoData();
    end;

    procedure GenerateDemoData()
    var
        itemRecord: Record Item;
        itemImageCodeUnit: Codeunit PowerAppsItemImages;
    begin

        // Add item catagories
        AddItemCatagories('Finished goods', 'finishedGoods');
        addItemCatagories('Consumables', 'consumables');
        addItemCatagories('Maintenance', 'maintenance');

        // Add items
        AddItem('CO001', 'Contoso PRO 2018 San Diego', 'Contoso PRO 2018 San Diego', 'finishedGoods', 699, itemImageCodeUnit.C0001_SanDiego());
        AddItem('CO002', 'Contoso PRO 2019 Las Vegas', 'Contoso PRO 2019 Las Vegas', 'finishedGoods', 850, itemImageCodeUnit.C0002_LasVegas());
        addItem('CO003', 'Contoso PRO 2022 Orlando', 'Contoso PRO 2022 Orlando', 'finishedGoods', 499, itemImageCodeUnit.C0003_2022Orlando());
        addItem('CO004', 'Contoso PRO 2023 Orlando', 'Contoso PRO 2023 Orlando', 'finishedGoods', 699, itemImageCodeUnit.C0004_2023Orlando());

        // Add unit of measure      
        AddItemUnitOfMeasure('CO001');
        AddItemUnitOfMeasure('CO002');
        AddItemUnitOfMeasure('CO003');
        AddItemUnitOfMeasure('CO004');

    end;

    procedure AddItem(ItemNumber: Text; ItemName: Text; description: Text; itemCategory: Text; unitPrice: Decimal; itemPicture: Text)
    var
        itemRecord: Record Item;
        inventoryGroup: Record "Inventory Posting Group";
        itemUnitOfMeasure: Record "Item Unit of Measure";
        genProdPostingGroup: Record "Gen. Product Posting Group";
        taxGroupCode: Record "Tax Group";
    begin
        // Note we can change these to be specific things if we want to 
        inventoryGroup.FindFirst();
        taxGroupCode.FindFirst();
        genProdPostingGroup.Get('RETAIL');

        // Set up the item
        itemRecord.Init();
        itemRecord.Validate("No.", ItemNumber);
        itemRecord.Validate(Description, ItemName);
        itemRecord.Validate(LongDescription, description);
        itemRecord.Validate("Unit Price", unitPrice);
        itemRecord.Validate("Item Category Code", itemCategory);
        itemRecord.Validate("Inventory Posting Group", inventoryGroup.Code);
        itemRecord.Validate("Gen. Prod. Posting Group", genProdPostingGroup.Code);
        itemRecord.Validate("Tax Group Code", taxGroupCode.Code);
        itemRecord.Validate(IsAvialableForFieldWorker, true);
        addImageToItem(itemPicture, itemRecord);

        // Save the item
        itemRecord.Insert(true);

    end;


    procedure AddItemCatagories(description: Text; code: Text)
    var
        itemCatagory: Record "Item Category";
    begin
        if itemCatagory.Get(code) then
            exit;

        itemCatagory.Init();
        itemCatagory.Validate(description, description);
        itemCatagory.Validate(Code, code);
        itemCatagory.Insert(true);
    end;

    procedure AddItemUnitOfMeasure(itemNumber: Text)
    var
        itemUnitOfMeasure: Record "Item Unit of Measure";
        itemRecord: Record Item;
    begin
        itemUnitOfMeasure.SetRange("Item No.", itemNumber);
        itemUnitOfMeasure.SetRange(Code, 'PCS');
        if itemUnitOfMeasure.FindFirst() then
            exit;

        itemUnitOfMeasure.Init();
        itemUnitOfMeasure.Validate("Item No.", itemNumber);
        itemUnitOfMeasure.Validate(Code, 'PCS');
        itemUnitOfMeasure.Insert(true);

        itemRecord.Get(itemNumber);
        itemRecord.validate("Base Unit of Measure", 'PCS');
        itemRecord.Modify(true);
    end;

    procedure addImageToItem(Base64Img: Text; var itemRecord: Record Item)
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        Outstr := TempBlob.CreateOutStream();
        Base64Convert.FromBase64(Base64Img, Outstr);
        itemRecord.Picture.ImportStream(TempBlob.CreateInStream(), 'Image demo data for Item');
    end;

}