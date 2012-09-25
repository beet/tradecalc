function updateTradeCalculationForm() {
  units = getUnits();
  purchase_price = getPurchasePrice();
  stop_loss_exit_price = getStopLossExitPrice();
  target_sale_price = getTargetSalePrice();
  parameters = {
    'trade_calculation[units]': units, 
    'trade_calculation[purchase_price]': purchase_price,
    'trade_calculation[stop_loss_exit_price]': stop_loss_exit_price,
    'trade_calculation[target_sale_price]': target_sale_price
  };
  new Ajax.Request( '/trade_calculations/update_calculation_form', {
    asynchronous: true, 
    evalScripts: true, 
    parameters: parameters
  });
}

function updateTradeLogForm(){
  units = getTradeLogUnits();
  price = getTradeLogPrice();
  parameters = {
    'trade_log[units]': units,
    'trade_log[price]': price
  }
  new Ajax.Request( '/trade_logs/update_calculation_form', {
    asynchronous: true, 
    evalScripts: true, 
    parameters: parameters
  });
}

/* Trade Calculation fields */
function symbolField() {return $('trade_calculation_symbol')}
function unitsField() {return $('trade_calculation_units')}
function purchasePriceField() {return $('trade_calculation_purchase_price')}
function stopLossExitPriceField() {return  $('trade_calculation_stop_loss_exit_price')}
function targetSalePriceField() {return $('trade_calculation_target_sale_price')}
/* Trade Log fields */
function tradeLogUnitsField() {return $('trade_log_units')}
function tradeLogPriceField() {return $('trade_log_price')}

/* Trade Calculation accessor methods */
function getSymbol() {return symbolField().value}
function getUnits() { return unitsField().value }
function getPurchasePrice() { return purchasePriceField().value }
function getStopLossExitPrice() { return stopLossExitPriceField().value }
function getTargetSalePrice() { return targetSalePriceField().value }
/* Trade Log accessor methods */
function getTradeLogUnits(){return tradeLogUnitsField().value}
function getTradeLogPrice(){return tradeLogPriceField().value}

/* Trade Calculator settor methods */
function setSymbol( symbol ) {symbolField().value = symbol}
function setUnits( units ) { unitsField().value = units }
function setPurchasePrice( price ) { purchasePriceField().value = price }
function setStopLossExitPrice( price ) { stopLossExitPriceField().value = price }
function setTargetSalePrice( price ) { targetSalePriceField().value = price }
/* Trade Log settor methods */
function setTradeLogUnits(units) {tradeLogUnitsField().value = units}
function setTradeLogPrice(price) {tradeLogPriceField().value = price}

function roundNumber( number ) {
	var result = Math.round(number*Math.pow(10,2))/Math.pow(10,2);
	return result;
}

function promptForSymbol() {
  symbol = getSymbol();
  while (symbol=='') {
    symbol = prompt('Enter the symbol');
    setSymbol( symbol );
  }
  return symbol;
}

function promptForPurchasePrice() {
  purchase_price = getPurchasePrice();
  while (purchase_price=='') {
    purchase_price = prompt('Enter the purchase price');
    setPurchasePrice( purchase_price );
  }
  return purchase_price;
}

function promptForTradeLogPrice(){
  price = getTradeLogPrice();
  while (price==''){
    price = prompt('Enter the price');
    setTradeLogPrice(price);
  }
  return price;
}

function promptForUnits() {
  units = getUnits();
  while (units=='') {
    units = prompt('Enter the units');
    setUnits( units );
  }
  return units;
}

function promptForTradeLogUnits() {
  units = getTradeLogUnits();
  while (units==''){
    units = prompt('Enter the units');
    setTradeLogUnits(units);
  }
  return units;
}

function promptForFullCost() {
  full_cost = '';
  while (full_cost=='') {full_cost = prompt('Enter your target full cost')}
  return full_cost;
}

function adjustStopLossExitToRisk( risk ) {
  units = promptForUnits();
  purchase_price = promptForPurchasePrice();
  full_cost = parseFloat( units * purchase_price );
  stop_loss_exit = roundNumber( parseFloat( (full_cost - risk) / units ) );
  setStopLossExitPrice( stop_loss_exit );
  updateTradeCalculationForm();
}

function adjustUnitsToPriceAndCost() {
  purchase_price = promptForPurchasePrice();
  full_cost = promptForFullCost();
  units = parseInt( full_cost / purchase_price );
  setUnits( units );
  updateTradeCalculationForm();
}

function adjustTradeLogUnitsToPriceAndCost(){
  price = promptForTradeLogPrice();
  full_cost = promptForFullCost();
  units = parseInt( full_cost / price );
  setTradeLogUnits( units );
  updateTradeLogForm();
}

function adjustPurchasePriceToUnitsAndCost() {
  units = promptForUnits();
  full_cost = promptForFullCost();
  purchase_price = full_cost / units;
  setPurchasePrice( purchase_price );
  updateTradeCalculationForm();
}

function adjustTradeLogPriceToUnitsAndCost(){
  units = promptForTradeLogUnits();
  cost = promptForFullCost();
  price = cost / units
  setTradeLogPrice(price);
  updateTradeLogForm();
}

function setPurchasePriceToQuote() {
  symbol = promptForSymbol();
  parameters = { 'symbol': symbol }
  new Ajax.Request( '/trade_calculations/set_purchase_price_to_quote', {
    asynchronous: true, 
    evalScripts: true, 
    parameters: parameters,
    onCreate: function(){ $('purchasePriceSpinner').show()},
    onComplete: function(){$('purchasePriceSpinner').hide()},
    onFailure: function(){$('purchasePriceSpinner').hide();alert('Error, unable to fetch quote')}
  });
}

function setSalePriceToQuote() {
  symbol = promptForSymbol();
  parameters = { 'symbol': symbol }
  new Ajax.Request( '/trade_calculations/set_sale_price_to_quote', {
    asynchronous: true, 
    evalScripts: true, 
    parameters: parameters,
    onCreate: function(){ $('salePriceSpinner').show()},
    onComplete: function(){$('salePriceSpinner').hide()},
    onFailure: function(){$('salePriceSpinner').hide();alert('Error, unable to fetch quote')}
  });
}

/* The symbol value will be passed in from the view template from the trade log's trade calculation */
function setTradeLogPriceToQuote(symbol){
  parameters = { 'symbol': symbol }
  new Ajax.Request( '/trade_logs/set_price_to_quote', {
    asynchronous: true, 
    evalScripts: true, 
    parameters: parameters,
    onCreate: function(){ $('priceSpinner').show()},
    onComplete: function(){$('priceSpinner').hide()},
    onFailure: function(){$('priceSpinner').hide();alert('Error, unable to fetch quote')}
  });
}


function setTradeLogDateToToday(){
  currentDate = new Date()
  day = currentDate.getDate();
  month = currentDate.getMonth() + 1; /* Not zero indexed */
  year = currentDate.getFullYear();
  $('trade_log_date_1i').value = year;
  $('trade_log_date_2i').value = month;
  $('trade_log_date_3i').value = day;
}
