@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum Item DDH'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_DDH_SUM_ITEM as select from I_PurchaseOrderItemAPI01 as poi

{
    key poi.PurchaseOrder,
    poi.DocumentCurrency,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
    sum(poi.NetAmount) as TongCong  
}
where poi.PurchasingDocumentDeletionCode = ''
group by poi.PurchaseOrder, poi.DocumentCurrency
