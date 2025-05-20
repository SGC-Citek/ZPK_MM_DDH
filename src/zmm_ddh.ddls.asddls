@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Đơn đặt hàng'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_DDH
  as select from    I_PurchaseOrderAPI01         as po
    inner join      I_PurchaseOrderItemAPI01     as poi          on  poi.PurchaseOrder                  = po.PurchaseOrder
                                                                 and poi.PurchasingDocumentDeletionCode = ''
    left outer join I_Plant                      as plt          on poi.Plant = plt.Plant
    left outer join I_StorageLocation            as stgl         on poi.StorageLocation = stgl.StorageLocation
    left outer join I_StorageLocationAddress     as stgla        on  poi.Plant           = stgla.Plant
                                                                 and poi.StorageLocation = stgla.StorageLocation
    left outer join I_PurchaseOrderType          as pot          on pot.PurchaseOrderType = po.PurchaseOrderType
    left outer join I_PurchasingDocumentTypeText as pdtt         on  pdtt.PurchasingDocumentType     = pot.PurchaseOrderType
                                                                 and pdtt.PurchasingDocumentCategory = 'F'
                                                                 and pdtt.Language                   = $session.system_language
  //    left outer join I_PurOrdScheduleLineAPI01    as pchl     on  po.PurchaseOrder      = pchl.PurchaseOrder
  //                                                             and poi.PurchaseOrderItem = pchl.PurchaseOrderItem
    left outer join I_Supplier                   as supplier     on po.Supplier = supplier.Supplier
    left outer join I_Supplier                   as supctr       on poi.Subcontractor = supctr.Supplier
    left outer join I_SuplrBankDetailsByIntId    as supbd        on  supplier.Supplier             = supbd.Supplier
                                                                 and supbd.BPBankAccountInternalID = '0001'
    left outer join I_CompanyCode                as compc        on po.CompanyCode = compc.CompanyCode
    left outer join I_OrganizationAddress        as orgadd       on compc.AddressID = orgadd.AddressID
    left outer join ZWM_GETCREATEDNAME           as user         on user.UserID = po.CreatedByUser
  //    left outer join I_CustomFieldCodeListText    as cfclt    on  cfclt.CustomFieldID = 'YY1_PTTHANHTOAN'
  //                                                             and cfclt.Language      = $session.system_language
  //                                                             and cfclt.Code          = po.YY1_PTThanhtoan_PDH
    left outer join I_Address_2                  as addresssup   on supplier.AddressID = addresssup.AddressID
    left outer join I_Address_2                  as addmanualsup on po.ManualSupplierAddressID = addmanualsup.AddressID
  association [1..1] to I_Address_2         as addressdeli  on poi.ManualDeliveryAddressID = addressdeli.AddressID
  association [1..1] to I_Address_2         as addresssloc  on stgla.AddressID = addresssloc.AddressID
  association [1..1] to I_Address_2         as addressplt   on plt.AddressID = addressplt.AddressID
  association [1..1] to I_Address_2         as addresssctr  on supctr.AddressID = addresssctr.AddressID
  association [1..1] to ZWM_GET_PHONENUMBER as phonencctmp1 on addresssup.AddressID = phonencctmp1.AddressID
  association [1..1] to ZWM_GET_PHONENUMBER as phonencctmp2 on addmanualsup.AddressID = phonencctmp2.AddressID
  association [1..1] to I_Bank_2            as bank         on bank.BankInternalID = supbd.Bank
  association [0..1] to ZMM_DDH_SUM_ITEM    as _SUM         on po.PurchaseOrder = _SUM.PurchaseOrder
  association [0..1] to ztb_mm_ddh          as _ztb         on po.PurchaseOrder = _ztb.ebeln
{
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_PurchaseOrderAPI01', element: 'PurchaseOrder'},
      distinctValues : true
      }]
  key po.PurchaseOrder,
      @UI.hidden: true
  key poi.PurchaseOrderItem,
      @UI.hidden: true
  key po.PurchasingProcessingStatus,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_Plant', element: 'Plant'},
      distinctValues : true
      }]
      @Consumption.filter:{mandatory: true, defaultValue: '1000'}
      poi.Plant,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_Supplier', element: 'Supplier'},
      distinctValues : true
      }]
      supplier.Supplier,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_CompanyCodeStdVH', element: 'CompanyCode'},
      distinctValues : true
      }]
      @Consumption.filter:{mandatory: true, defaultValue: '1000'}
      po.CompanyCode,
      @Consumption.filter.hidden: true
      supplier.SupplierName,
      po.PurchasingOrganization,
      po.PurchasingGroup,
      @Consumption.filter:{selectionType: #INTERVAL}
      po.PurchaseOrderDate,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZMM_GET_USER', element: 'UserID'},
      distinctValues : true
      }]
      user.UserID                                                                                     as CreatedByUser,
//      @UI: {lineItem: [ { position: 90, label: 'Created By' } ], identification: [ { position: 90,  label: 'Created By' } ]
//      }
//      @EndUserText.label: 'Created By'
      user.UserDescription                                                                            as CreatedByUserName,
      @Consumption.filter.hidden: true
      po.CreationDate,
      @Consumption.filter.hidden: true
      po.PurchaseOrderType,
      @Consumption.filter.hidden: true
      pdtt.PurchasingDocumentTypeName                                                                 as POTypeName,
      @Consumption.filter.hidden: true
      poi.Material                                                                                    as Product,
      @Consumption.filter.hidden: true
      poi.PurchaseOrderQuantityUnit                                                                   as Unit,
      @Consumption.filter.hidden: true
      @Semantics.quantity.unitOfMeasure: 'Unit'
      poi.OrderQuantity,
      @UI.hidden: true
      po.YY1_Ngaygiaohang_PDH                                                                         as NgayGiaohang,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.char( 1000 ))                                                                   as TenHang1,
      @UI.hidden: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.char( 1000 ))                                                                   as TenHang2,
      @UI.hidden: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.char( 1000 ))                                                                   as TenHang3,
      @UI.hidden: true
      poi.PurchaseOrderItemText                                                                       as TenHang4,
      @UI.hidden: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.char( 1000 ))                                                                   as Ghichu,
      @UI.hidden: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.char( 1000 ))                                                                   as POScheduleLine,
      @UI.hidden: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.char( 1000 ))                                                                   as Ghichu1,
      @UI.hidden: true
      poi.PurchaseRequisition,
      @UI.hidden: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.char( 1000 ))                                                                   as Pr,
      @UI.hidden: true
      case
            when  (supplier.BusinessPartnerName2 is initial and supplier.BusinessPartnerName3 is initial
            and supplier.BusinessPartnerName4 is initial )
                then supplier.BusinessPartnerName1
            else
                concat_with_space(supplier.BusinessPartnerName2,concat_with_space(supplier.BusinessPartnerName3, supplier.BusinessPartnerName4,1) ,1)
        end                                                                                           as TenNCC_TMP1,

      @UI.hidden: true
      case
            when  (addmanualsup.OrganizationName2 is initial and addmanualsup.OrganizationName3 is initial
            and addmanualsup.OrganizationName4 is initial )
                then addmanualsup.OrganizationName1
            else
                concat_with_space(addmanualsup.OrganizationName2,concat_with_space(addmanualsup.OrganizationName3, addmanualsup.OrganizationName4,1) ,1)
        end                                                                                           as TenNCC_TMP2,

      @UI.hidden: true
      case
        when $projection.TenNCC_TMP2 <> ''
            then $projection.TenNCC_TMP2
        else
             $projection.TenNCC_TMP1
        end                                                                                           as TenNCC,

      @UI.hidden: true
      concat_with_space( addresssup.StreetName,
      concat_with_space( addresssup.StreetPrefixName1,
      concat_with_space( addresssup.StreetPrefixName2,
      concat_with_space( addresssup.StreetSuffixName1, addresssup.StreetSuffixName2,1 ),1),1) ,1)     as DiachiNCC_TMP1,

      @UI.hidden: true
      concat_with_space( addmanualsup.StreetName,
      concat_with_space( addmanualsup.StreetPrefixName1,
      concat_with_space( addmanualsup.StreetPrefixName2,
      concat_with_space( addmanualsup.StreetSuffixName1, addmanualsup.StreetSuffixName2,1 ),1),1) ,1) as DiachiNCC_TMP2,

      @UI.hidden: true
      case
        when $projection.DiachiNCC_TMP2 <> ''
            then $projection.DiachiNCC_TMP2
        else
             $projection.DiachiNCC_TMP1
        end                                                                                           as DiachiNCC,


      @UI.hidden: true
      addresssup._EmailAddress.EmailAddress                                                           as EmailNCC_TMP1,
      @UI.hidden: true
      addmanualsup._EmailAddress.EmailAddress                                                         as EmailNCC_TMP2,

      @UI.hidden: true
      case
        when $projection.EmailNCC_TMP2 is not initial
            then $projection.EmailNCC_TMP2
        else
             $projection.EmailNCC_TMP1
        end                                                                                           as EmailNCC,

      @UI.hidden: true
      phonencctmp1.InternationalPhoneNumber                                                           as PhoneNCC_TMP1,
      @UI.hidden: true
      phonencctmp2.InternationalPhoneNumber                                                           as PhoneNCC_TMP2,
      @UI.hidden: true
      case
        when $projection.PhoneNCC_TMP2 is not initial
            then $projection.PhoneNCC_TMP2
        else
             $projection.PhoneNCC_TMP1
        end                                                                                           as PhoneNCC,

      @UI.hidden: true
      supplier.TaxNumber1                                                                             as TaxSupplier,
      @UI.hidden: true
      supbd.BankAccount,
      @UI.hidden: true
      bank.BankName,
      @UI.hidden: true
      bank.BankBranch,
      @UI.hidden: true
      po.YY1_Yeucaudacbiet_PDH                                                                        as YCDB,
      @UI.hidden: true
      concat_with_space(orgadd.AddresseeName1, orgadd.AddresseeName2 ,1)                              as TenXHD,
      @UI.hidden: true
      concat_with_space( orgadd.StreetName,
      concat_with_space( orgadd.StreetPrefixName1,
      concat_with_space( orgadd.StreetPrefixName2,
      concat_with_space( orgadd.StreetSuffixName1, orgadd.StreetSuffixName2,1 ),1),1) ,1)             as DiachiXHD,
      @UI.hidden: true
      compc.VATRegistration                                                                           as MST,
      @UI.hidden: true
      po.YY1_Chungtuyeucau_PDH                                                                        as CTYC,
      @UI.hidden: true
      //      cfclt.Description                                                                             as PTTT, //Phương thức thanh toán
      po.YY1_PhThThanhToan_PDH                                                                        as PTTT, //Phương thức thanh toán
      @UI.hidden: true
      po.YY1_Nguoilienhe_PDH                                                                          as NguoiLienHe,
      @UI.hidden: true
      po.YY1_Ngayinphieu_PDH                                                                          as Ngayinphieu,
      @UI.hidden: true
      //      case
      //         when $projection.CreatedByUser <> ''
      //             then $projection.CreatedByUser
      //         else po.YY1_Nguoilapphieu_PDH
      //      end                                                                                             as Nguoilapphieu,
      case
         when po.YY1_Nguoilapphieu_PDH <> ''
             then po.YY1_Nguoilapphieu_PDH
         else $projection.CreatedByUserName
      end                                                                                             as Nguoilapphieu,
      @UI.hidden: true
      concat_with_space( addressdeli.StreetName,
      concat_with_space( addressdeli.StreetPrefixName1,
      concat_with_space( addressdeli.StreetPrefixName2,
      concat_with_space( addressdeli.StreetSuffixName1, addressdeli.StreetSuffixName2,1 ),1),1) ,1)   as DiachiGHTmp,

      @UI.hidden: true
      concat_with_space( addresssloc.StreetName,
      concat_with_space( addresssloc.StreetPrefixName1,
      concat_with_space( addresssloc.StreetPrefixName2,
      concat_with_space( addresssloc.StreetSuffixName1, addresssloc.StreetSuffixName2,1 ),1),1) ,1)   as DiachiSloc,

      @UI.hidden: true
      concat_with_space( addressplt.StreetName,
      concat_with_space( addressplt.StreetPrefixName1,
      concat_with_space( addressplt.StreetPrefixName2,
      concat_with_space( addressplt.StreetSuffixName1, addressplt.StreetSuffixName2,1 ),1),1) ,1)     as DiachiPlt,

      @UI.hidden: true
      concat_with_space( addresssctr.StreetName,
      concat_with_space( addresssctr.StreetPrefixName1,
      concat_with_space( addresssctr.StreetPrefixName2,
      concat_with_space( addresssctr.StreetSuffixName1, addresssctr.StreetSuffixName2,1 ),1),1) ,1)   as DiachiSctr, // Địa chỉ Subcontractor

      @UI.hidden: true
      case
           when  (addressdeli.OrganizationName2 is initial and addressdeli.OrganizationName3 is initial
           and addressdeli.OrganizationName4 is initial )
               then addressdeli.OrganizationName1
           else
               concat_with_space(addressdeli.OrganizationName2,concat_with_space(addressdeli.OrganizationName3, addressdeli.OrganizationName4,1) ,1)
       end                                                                                            as TenNgNhanTmp,

      @UI.hidden: true
      case
          when  (addresssctr.OrganizationName2 is initial and addresssctr.OrganizationName3 is initial
          and addresssctr.OrganizationName4 is initial )
              then addresssctr.OrganizationName1
          else
              concat_with_space(addresssctr.OrganizationName2,concat_with_space(addresssctr.OrganizationName3, addresssctr.OrganizationName4,1) ,1)
      end                                                                                             as TenNgNhanSctr,

      @UI.hidden: true
      case
          when  (addressplt.OrganizationName2 is initial and addressplt.OrganizationName3 is initial
          and addressplt.OrganizationName4 is initial )
              then addressplt.OrganizationName1
          else
              concat_with_space(addressplt.OrganizationName2,concat_with_space(addressplt.OrganizationName3, addressplt.OrganizationName4,1) ,1)
      end                                                                                             as TenNgNhanPlt,

      @UI.hidden: true
      case
        when addressdeli.AddressID <> ''
            then $projection.DiachiGHTmp
        when addresssctr.AddressID <> ''
            then $projection.DiachiSctr
        when addresssloc.AddressID <> ''
            then $projection.DiachiSloc
        else
            $projection.DiachiPlt
        end                                                                                           as DiachiGH,

      @UI.hidden: true
      case
       when $projection.TenNgNhanTmp <> ''
           then $projection.TenNgNhanTmp
       when $projection.TenNgNhanSctr <> ''
           then $projection.TenNgNhanSctr
       else
           $projection.TenNgNhanPlt
       end                                                                                            as TenNgNhan,

      @Consumption.filter.hidden: true
      _ztb.slin                                                                                       as Solanin,
      @Consumption.filter.hidden: true
      _ztb.datein                                                                                     as Datein,
      @UI.hidden: true
      poi.DocumentCurrency,
      @UI.hidden: true
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      cast(_SUM.TongCong as abap.curr( 31, 2 ))                                                       as TongCong,
      @UI.hidden: true
      poi.PurchaseOrderQuantityUnit                                                                   as DVT,
      @UI.hidden: true
      @Semantics.quantity.unitOfMeasure: 'DVT'
      poi.OrderQuantity                                                                               as SoLuong,
      @UI.hidden: true
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      poi.NetPriceAmount,
      @UI.hidden: true
      cast(poi.NetPriceAmount as abap.dec(12,2))                                                      as NetPriceAmountTMP,
      @UI.hidden: true
      poi.NetPriceQuantity,
      @UI.hidden: true
      case
        when $projection.netpricequantity <> 0
          then cast($projection.NetPriceAmountTMP / cast($projection.netpricequantity as abap.dec(13,2)) as abap.dec(31,2))
        else
            $projection.NetPriceAmountTMP
        end                                                                                           as NoVATTMP,
      @UI.hidden: true
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      cast($projection.NoVATTMP as abap.curr( 12, 2 ))                                                as NoVAT,
      @UI.hidden: true
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      poi.NetAmount                                                                                   as ThanhTien,
      @UI.hidden: true
      cast(poi.OverdelivTolrtdLmtRatioInPct as abap.dec(12,2))                                        as OverdelivTolrtdLmtRatioInPct,
      @UI.hidden: true
      poi.UnlimitedOverdeliveryIsAllowed                                                              as UnlimitedOverdeliveryIsAllowed,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_GET_LONG_TEXT'
      cast('' as abap.dats( 8 ))                                                                      as NgayduyetPO

}
