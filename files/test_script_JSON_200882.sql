execute block
returns (
    uid varchar(40),
    val varchar(4096),
    n integer,
    i integer,
    deal_date date,
    gracedate date,
    graceenddate date,
    fullcost_sum numeric(18,2),
    fullcost_date date,
    debtcurr_othersum numeric(18,2),
    debtoverdue_othersum numeric(18,2)
)
as
declare variable js BLOB SUB_TYPE 1 SEGMENT SIZE 80 CHARACTER SET UTF8;
declare variable bl BLOB SUB_TYPE 1 SEGMENT SIZE 80 CHARACTER SET UTF8;

declare function str2curr (
       str varchar(255))
    returns numeric(18,2)
    as
    begin
      return replace(str, ',', '.');
      when any do
        return null;
    end

declare function str2date (
       date_str varchar(20))
    returns date
    as
    begin
      return iif(date_str = '-', null, date_str);
    end

begin
    bl = '{"response": {"basePart": {"contract": [{
            "uid": {"id": "83a40513-ecd3-1f52-b2eb-3c8bb9de94e5-7" },
            "deal": {
                "ratio": "2",
                "date": "29.09.2017",
                "endDate": "02.04.2018"},
            "contractAmount": [{
                "sum": "15000,00",
                "currency": "RUB"}],
            "paymentTerms": {
                "graceDate": "29.09.2017",
                "graceEndDate": "29.12.2017"},
            "jointDebtors": {"sign": "0"},
            "fullCost": {
                "percent": "91.047",
                "sum": "0,00",
                "date": "30.01.2022"},
            "debt": [{
                    "sign": "0",
                    "signCalcLastPayout": "1",
                    "calcDate": "26.03.2018",
                    "otherSum": "0,00"}],
            "debtCurrent": [{
                    "date": "-",
                    "signCalcLastPayout": "1",
                    "otherSum": "0,00"}],
            "debtOverdue": [{
                    "date": "-",
                    "signCalcLastPayout": "1",
                    "calcDate": "26.03.2018",
                    "otherSum": "0,00"}],
            "payments": [{
                    "lastPayoutDate": "-",
                    "lastPayoutSum": "0,00",
                    "paymentsDeadlineType": "2",
                    "overdueDay": "0"}]}
            ]}}}';

   js = json_query(:bl, 'lax $.response.basePart.contract ? (exists (@.uid))' with array wrapper); --
    n = json_value(json_query(:js, 'lax $.size()' returning varchar(255) with array wrapper), '$.double()');

    i = 0;
    while (i < n) do
    begin
     val = json_query(:js, 'lax $[$TR]' passing :i as tr with array wrapper);
      if (val is not null) then
      begin

        uid = json_value(:val, '$.uid.id');
        deal_date = str2date(json_value(:val, '$.deal.date'));
        gracedate = str2date(json_value(:val, '$.paymentTerms.graceDate'));
        graceenddate = str2date(json_value(:val, '$.paymentTerms.graceEndDate'));
        fullcost_sum = str2curr(json_value(:val, '$.fullCost.sum'));
        fullcost_date = str2date(json_value(:val, '$.fullCost.date'));
        debtcurr_othersum = str2curr(json_value(:val, '$.debtCurrent[0].otherSum'));
        debtoverdue_othersum = str2curr(json_value(:val, '$.debtOverdue[0].otherSum'));

        suspend;

      end
      i = :i + 1;
    end

end