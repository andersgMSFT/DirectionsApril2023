codeunit 51001 PowerAppsDemoDataGenerator
{
    procedure DeleteDemoDataForPowerApps()
    var
        itemRecord: Record Item;
        cutsomerRecord: Record Customer;
    begin
        // Delete all added items
        itemRecord.SetRange(SoldInRestaurant, true);
        itemRecord.DeleteAll(true);

        // Delete all added tables (customers)
        cutsomerRecord.SetRange(IsTable, true);
        cutsomerRecord.DeleteAll(true);
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
        AddItemCatagories('Warm drinks', 'warmDrinks');

        // Add items
        AddItem('W0001', 'Caffè', 'warmDrinks', '', 'Hawaii dark roast has scents of cedar and roasted hazelnuts with flavors of chocolate, toasted nuts, and a tangy strawberry finish.', 2.00, itemImageCodeUnit.W0001_Caffe());

        // Add unit of measure      
        AddItemUnitOfMeasure('W0001');

    end;

    procedure AddItem(ItemNumber: Text; ItemName: Text; itemCategory: Text; unitPrice: Decimal; height: Decimal; width: Decimal; Depth: Decimal; itemPicture: Text)
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
        itemRecord.Validate("Unit Price", unitPrice);
        itemRecord.Validate("Item Category Code", itemCategory);
        itemRecord.Validate("Inventory Posting Group", inventoryGroup.Code);
        itemRecord.Validate("Gen. Prod. Posting Group", genProdPostingGroup.Code);
        itemRecord.Validate("Tax Group Code", taxGroupCode.Code);
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