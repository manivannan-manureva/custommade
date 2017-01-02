{*
* 2007-2012 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2012 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

{capture name=path}{l s='Your shopping cart'}{/capture} 

{assign var='current_step' value='summary'}
{include file="$tpl_dir./order-steps.tpl"}

<h1 id="cart_title">{l s='Mon panier'} 
{if !isset($empty)}
<a href="{if $back}{$link->getPageLink('order', true, NULL, 'step=1&amp;back={$back}')}{else}{$link->getPageLink('order', true, NULL, 'step=1')}{/if}" class="exclusive standard-checkout" title="{l s='Next'}">{l s='Commander'}</a>
{else}
<a href="{$base_dir}" class="exclusive standard-checkout" title="{l s='Accueil'}">{l s='Accueil'}</a>
{/if}
</h1>

	{if isset($account_created)}
		<p class="success">
			{l s='Your account has been created.'}
		</p>
	{/if}
	{include file="$tpl_dir./errors.tpl"}

	{if isset($empty)}
		<p class="warning">{l s='Your shopping cart is empty.'}</p>
	{elseif $PS_CATALOG_MODE}
		<p class="warning">{l s='This store has not accepted your new order.'}</p>
	{else}
		<script type="text/javascript">
		// <![CDATA[
		var currencySign = '{$currencySign|html_entity_decode:2:"UTF-8"}';
		var currencyRate = '{$currencyRate|floatval}';
		var currencyFormat = '{$currencyFormat|intval}';
		var currencyBlank = '{$currencyBlank|intval}';
		var txtProduct = "{l s='product' js=1}";
		var txtProducts = "{l s='products' js=1}";
		var deliveryAddress = {$cart->id_address_delivery|intval};
		// ]]>
		</script>
		<p style="display:none" id="emptyCartWarning" class="warning">{l s='Your shopping cart is empty.'}</p>
	
	<div id="order-detail-content" class="active table_block">
		<div class="content_cart_summary">
			<table id="cart_summary" class="std panier">
				<thead>
					<tr>
						<th class="cart_product first_item">{l s='Product'}</th>
						<th class="cart_description item">{l s='Description'}</th>
						<th class="cart_unit item">{l s='Unit price'}</th>
						<th class="cart_quantity item">{l s='Qty'}</th>
						<th class="cart_total item" colspan="2">{l s='Total'}</th>
					</tr>
				</thead>
				
				
				<tbody>
				{foreach $products as $product}
					{assign var='productId' value=$product.id_product}
					{assign var='productAttributeId' value=$product.id_product_attribute}
					{assign var='quantityDisplayed' value=0}
					{assign var='odd' value=$product@iteration%2}
					{assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId) || count($gift_products)}
					{* Display the product line *}
					{include file="modules/custommade/views/templates/front/shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first}
					{* Then the customized datas ones*}
					{if isset($customizedDatas.$productId.$productAttributeId)}
						{foreach $customizedDatas.$productId.$productAttributeId[$product.id_address_delivery] as $id_customization=>$customization}
							<tr id="product_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_{$product.id_address_delivery|intval}" class="product_customization_for_{$product.id_product}_{$product.id_product_attribute}_{$product.id_address_delivery|intval} {if $odd}odd{else}even{/if} customization alternate_item {if $product@last && $customization@last && !count($gift_products)}last_item{/if}">
								<td></td>
								<td colspan="3">
									<div class="customizationHelp">{l s='We will add the selected product to this photo:'}</div>
									{foreach $customization.datas as $type => $custom_data}
										{if $type == $CUSTOMIZE_FILE}
											<div class="customizationUploaded">
												<ul class="customizationUploaded">
													{foreach $custom_data as $picture}
														<li><img src="{$pic_dir}{$picture.value}_small" alt="" class="customizationUploaded" /></li>
													{/foreach}
												</ul>
											</div>
										{elseif $type == $CUSTOMIZE_TEXTFIELD}
											<ul class="typedText">
												{foreach $custom_data as $textField}
													<li>
														{if $textField.name}
															{$textField.name}
														{else}
															{l s='Text #'}{$textField@index+1}
														{/if}
														{l s=':'} {$textField.value}
													</li>
												{/foreach}

											</ul>
										{/if}

									{/foreach}
								</td>
								{*<td class="cart_quantity" colspan="2">
									{if isset($cannotModify) AND $cannotModify == 1}
										<span style="float:left">{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}</span>
									{else}
										{strip}<input type="hidden" value="{$customization.quantity}" name="quantity_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_{$product.id_address_delivery|intval}_hidden"/>
										<input size="2" type="text" value="{$customization.quantity}" class="cart_quantity_input" name="quantity_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_{$product.id_address_delivery|intval}"/>
										<div class="cart_quantity_button">
										<a rel="nofollow" class="cart_quantity_up" id="cart_quantity_up_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery}&amp;id_customization={$id_customization}&amp;token={$token_cart}")}" title="{l s='Add'}"><img src="{$img_dir}icon/quantity_up.gif" alt="{l s='Add'}" /></a><br />
										{if $product.minimal_quantity < ($customization.quantity -$quantityDisplayed) OR $product.minimal_quantity <= 1}
										<a rel="nofollow" class="cart_quantity_down" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery}&amp;id_customization={$id_customization}&amp;op=down&amp;token={$token_cart}")}" title="{l s='Subtract'}">
											<img src="{$img_dir}icon/quantity_down.gif" alt="{l s='Subtract'}" />
										</a>
										{else}
										<a class="cart_quantity_down" style="opacity: 0.3;" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_{$id_customization}" href="#" title="{l s='Subtract'}">
											<img src="{$img_dir}icon/quantity_down.gif" alt="{l s='Subtract'}" />
										</a>
										{/if}
										</div>{/strip}
									{/if}
								</td>*}
								<td class="cart_delete">
									{if isset($cannotModify) AND $cannotModify == 1}
									{else}
										<div>
											<a rel="nofollow" class="cart_quantity_delete" id="{$product.id_product}_{$product.id_product_attribute}_{$id_customization}_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "delete&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_customization={$id_customization}&amp;id_address_delivery={$product.id_address_delivery}&amp;token={$token_cart}")}">{l s='Delete'}</a>
										</div>
									{/if}
								</td>
							</tr>
							{assign var='quantityDisplayed' value=$quantityDisplayed+$customization.quantity}
						{/foreach}
						{* If it exists also some uncustomized products *}
						{if $product.quantity-$quantityDisplayed > 0}{include file="./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first}{/if}
					{/if}
				{/foreach}
				{assign var='last_was_odd' value=$product@iteration%2}
				{foreach $gift_products as $product}
					{assign var='productId' value=$product.id_product}
					{assign var='productAttributeId' value=$product.id_product_attribute}
					{assign var='quantityDisplayed' value=0}
					{assign var='odd' value=($product@iteration+$last_was_odd)%2}
					{assign var='ignoreProductLast' value=isset($customizedDatas.$productId.$productAttributeId)}
					{assign var='cannotModify' value=1}
					{* Display the gift product line *}
					{include file="./shopping-cart-product-line.tpl" productLast=$product@last productFirst=$product@first}
				{/foreach}
			{if sizeof($discounts)} 
				{foreach $discounts as $discount}
					<tr class="cart_discount {if $discount@last}last_item{elseif $discount@first}first_item{else}item{/if}" id="cart_discount_{$discount.id_discount}">
						<td class="cart_discount_name" colspan="4" style="text-align:left">{$discount.name} 
						{if strlen($discount.code)}<a href="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}?deleteDiscount={$discount.id_discount}" class="price_discount_delete pull-right" title="{l s='Delete'}">{l s='Delete'}</a>{/if}
						</td>
						{*<td class="cart_discount_price">
							<span class="price-discount price">{if !$priceDisplay}{displayPrice price=$discount.value_real*-1}{else}{displayPrice price=$discount.value_tax_exc*-1}{/if}</span>
						</td>*}
						<td class="price_discount_del">
							<span class="price-discount">
							{if !$priceDisplay}{displayPrice price=$discount.value_real*-1}{else}{displayPrice price=$discount.value_tax_exc*-1}{/if}						
						</span>
						</td>
					</tr>
				{/foreach}
			{/if}
				</tbody>
			</table>
		</div>
		
		<h2>{l s='Récapitulatif'}</h2>
		<div class="bg_recapitulatif">
			<table class="std recapitulatif">
				<tfoot>
					<tr><td colspan="4"><strong class="uppercase">{l s='Nombre d\'articles'}</strong></td><td><span id="summary_products_quantity">{$productNumber}</span></td></tr> 
					<tr class="cart_total_voucher total_line" {if $total_discounts == 0}style="display:none"{/if}>
						<td colspan="4">
						<strong class="uppercase">{if $use_taxes && $display_tax_label}
							{l s='Total réductions HT:'}
						{else}
							{l s='Total réductions TTC'}
						{/if}</strong>
						</td>
						<td class="price-discount price" id="total_discount">
						{if $use_taxes && !$priceDisplay}
							{assign var='total_discounts_negative' value=$total_discounts * -1}
						{else}
							{assign var='total_discounts_negative' value=$total_discounts_tax_exc * -1}
						{/if}
						{displayPrice price=$total_discounts_negative}
						</td>
					</tr> 
					{if $total_shipping_tax_exc <= 0 && !isset($virtualCart)}
						<tr class="cart_total_delivery total_line">
							<td colspan="4"><strong class="uppercase">{l s='Transport'}</strong>
								<br/><i>{l s='Vous pourrez choisir le mode de livraison souhaité lors de la prochaine étape.'}</i>
								<br/><i>{l s='Les frais de port sont offerts pour les commandes d\'échantillons et pour les autres commandes à partir de 150€.'}</i></td>
							</td>
							<td class="price" id="total_shipping">{l s='Gratuit!'}</td>
						</tr>
					{else}
						{if $use_taxes}
							{if $priceDisplay}
								<tr class="cart_total_delivery total_line" {if $total_shipping_tax_exc <= 0} style="display:none;"{/if}>
								<td colspan="4"><strong class="uppercase ht">{l s='Transport'}</strong>
									<br/><i>{l s='Vous pourrez choisir le mode de livraison souhaité lors de la prochaine étape.'}</i>
									<br/><i>{l s='Les frais de port sont offerts pour les commandes d\'échantillons et pour les autres commandes à partir de 150€.'}</i></td>
									<td class="price" id="total_shipping">{displayPrice price=$total_shipping_tax_exc}</td>
								</tr>
							{else}
								<tr class="cart_total_delivery total_line"{if $total_shipping <= 0} style="display:none;"{/if}>
								<td colspan="4"><strong class="uppercase ttc">{l s='Transport'}</strong>
									<br/><i>{l s='Vous pourrez choisir le mode de livraison souhaité lors de la prochaine étape.'}</i>
									<br/><i>{l s='Les frais de port sont offerts pour les commandes d\'échantillons et pour les autres commandes à partir de 150€.'}</i></td>
									<td class="price" id="total_shipping" >{displayPrice price=$total_shipping}</td>
								</tr>
							{/if}
						{else}
							<tr class="cart_total_delivery total_line"{if $total_shipping_tax_exc <= 0} style="display:none;"{/if}>
								<td colspan="4"><strong class="uppercase">{l s='Transport'}</strong>
									<br/><i>{l s='Vous pourrez choisir le mode de livraison souhaité lors de la prochaine étape.'}</i>
									<br/><i>{l s='Les frais de port sont offerts pour les commandes d\'échantillons et pour les autres commandes à partir de 150€.'}</i></td>
								<td class="price" id="total_shipping" >{displayPrice price=$total_shipping_tax_exc}</td>
							</tr>
						{/if}
					{/if}
					{if $use_taxes}
					<tr class="cart_total_price total_line">
						<td colspan="4"><strong class="uppercase">{l s='Total HT'}</strong></td>
						<td class="price" id="total_price_without_tax">{displayPrice price=$total_price_without_tax}</td>
					</tr>
					<tr class="cart_total_tax total_line">
						<td colspan="4"><strong class="uppercase">{l s='Total taxes:'}</strong></td>
						<td class="price" id="total_tax">{displayPrice price=$total_tax}</td>
					</tr>
					{/if}
					<tr class="cart_total_price"> 
						{if $use_taxes}
						<td colspan="4" class="price total_price_container" id="total_price_container">
							<strong class="uppercase">{l s='Total TTC :'}</strong></td>
						<td><span id="total_price">{displayPrice price=$total_price}</span></td>
						{else}
						<td colspan="4" class="price total_price_container" id="total_price_container"><strong class="uppercase">{l s='Total:'}</strong></td>
						<td><span id="total_price">{displayPrice price=$total_price_without_tax}</span></td>
						{/if}
					</tr>
				</tfoot>
			</table>
		</div>
		<h2>{l s='Bons de réduction'}</h2>
		<div class="bg_reductions">
			<table class="std reductions">
				<tfoot>
					<tr>
						<td>
						{if $voucherAllowed}
						{if isset($errors_discount) && $errors_discount}
							<ul class="error">
							{foreach $errors_discount as $k=>$error}
								<li>{$error|escape:'htmlall':'UTF-8'}</li>
							{/foreach}
							</ul>
						{/if}
							<form action="{if $opc}{$link->getPageLink('order-opc', true)}{else}{$link->getPageLink('order', true)}{/if}" method="post" id="voucher">
								<fieldset>  
										<label for="discount_name">{l s='Code:'}</label>
										<input type="text" class="discount_name" id="discount_name" name="discount_name" value="{if isset($discount_name) && $discount_name}{$discount_name}{/if}" /> 
										<input type="submit" name="submitAddDiscount" id="submitAddDiscount" value="{l s='Ajouter ce code'}" class="button" />
								</fieldset>
								<input type="hidden" name="submitDiscount" />
							</form>
									{*if $displayVouchers}
										<p id="title" class="title_offers">{l s='Take advantage of our offers:'}</p>
										<div id="display_cart_vouchers">
										{foreach $displayVouchers as $voucher}
											{if $voucher.code != ''}<span onclick="$('#discount_name').val('{$voucher.code}');$('#voucher input.button').trigger('click');return false;" class="voucher_name">{$voucher.code}</span> - {/if}{$voucher.name}<br />
										{/foreach}
										</div>
									{/if*}
						{/if}
						</td>
					</tr>
				</tfoot>
			</table> 
		</div>
		<div class="clear"></div>
	</div>
		<div class="clear"></div>

	{if $show_option_allow_separate_package}
	<p>
		<input type="checkbox" name="allow_seperated_package" id="allow_seperated_package" {if $cart->allow_seperated_package}checked="checked"{/if} />
		<label for="allow_seperated_package">{l s='Send the available products first'}</label>
	</p>
	{/if}
	{if !$opc}
		{if Configuration::get('PS_ALLOW_MULTISHIPPING')}
			<p>
				<input type="checkbox" {if $multi_shipping}checked="checked"{/if} id="enable-multishipping" />
				<label for="enable-multishipping">{l s='I want to specify a delivery address for each individual product.'}</label>
			</p>
		{/if}
	{/if}
	{*
	<div id="HOOK_SHOPPING_CART">{$HOOK_SHOPPING_CART}</div>
	*}
	{* Define the style if it doesn't exist in the PrestaShop version*}
	{* Will be deleted for 1.5 version and more *}
	{if !isset($addresses_style)}
		{$addresses_style.company = 'address_company'}
		{$addresses_style.vat_number = 'address_company'}
		{$addresses_style.firstname = 'address_name'}
		{$addresses_style.lastname = 'address_name'}
		{$addresses_style.address1 = 'address_address1'}
		{$addresses_style.address2 = 'address_address2'}
		{$addresses_style.city = 'address_city'}
		{$addresses_style.country = 'address_country'}
		{$addresses_style.phone = 'address_phone'}
		{$addresses_style.phone_mobile = 'address_phone_mobile'}
		{$addresses_style.alias = 'address_title'}
	{/if}
 
 	<div class="content_cart_navigation">
		<p class="cart_navigation">
			{if !$opc}
				<a href="{if $back}{$link->getPageLink('order', true, NULL, 'step=1&amp;back={$back}')}{else}{$link->getPageLink('order', true, NULL, 'step=1')}{/if}" class="exclusive standard-checkout" title="{l s='Next'}">{l s='Commander'}</a>
				{*if Configuration::get('PS_ALLOW_MULTISHIPPING')}
					<a href="{if $back}{$link->getPageLink('order', true, NULL, 'step=1&amp;back={$back}')}{else}{$link->getPageLink('order', true, NULL, 'step=1')}{/if}&amp;multi-shipping=1" class="multishipping-button multishipping-checkout exclusive" title="{l s='Next'}">{l s='Commander'}</a>
				{/if*}
			{/if}
			<a href="{if (isset($smarty.server.HTTP_REFERER) && strstr($smarty.server.HTTP_REFERER, 'order.php')) || isset($smarty.server.HTTP_REFERER) && strstr($smarty.server.HTTP_REFERER, 'order-opc') || !isset($smarty.server.HTTP_REFERER)}{$link->getPageLink('index')}{else}{$smarty.server.HTTP_REFERER|escape:'htmlall':'UTF-8'|secureReferrer}{/if}" class="button_large" title="{l s='Continue shopping'}">{l s='Continue shopping'}</a>
		</p>
	</div>
		{*if !empty($HOOK_SHOPPING_CART_EXTRA)}
			<div class="clear"></div>
			<div class="cart_navigation_extra">
				<div id="HOOK_SHOPPING_CART_EXTRA">{$HOOK_SHOPPING_CART_EXTRA}</div>
			</div>
		{/if*}
	{/if}
 