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

<tr id="product_{$product.id_product}_{$product.id_product_attribute}_0_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}" class="{if isset($productLast) && $productLast && (!isset($ignoreProductLast) || !$ignoreProductLast)}last_item{elseif isset($productFirst) && $productFirst}first_item{/if} {if isset($customizedDatas.$productId.$productAttributeId) AND $quantityDisplayed == 0}alternate_item{/if} cart_item address_{$product.id_address_delivery|intval} {if $odd}odd{else}even{/if}">
	<td class="cart_product">
		<a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category, null, null, $product.id_shop, $product.id_product_attribute)|escape:'htmlall':'UTF-8'}"><img src="{$link->getImageLink($product.link_rewrite, $product.id_image, 'medium_default')}" alt="{Product::getLegendImageByProductId($product.id_product)|escape:'htmlall':'UTF-8'}" /></a>
	</td>
	<td class="cart_description">
		<p class="s_title_block"><a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category, null, null, $product.id_shop)|escape:'htmlall':'UTF-8'}">{$product.name|escape:'htmlall':'UTF-8'}<span class="hidden for_mobile"> {if $product.reference}- {$product.reference|escape:'htmlall':'UTF-8'}{/if}</span></a></p>
                {if isset($product.custommade.user_width)}<small class="cart_ref">{l s='Width : '}{$product.custommade.user_width|escape:'html':'UTF-8'}{l s=' CM'}</small><br/>{/if}
                {if isset($product.custommade.user_height)}<small class="cart_ref">{l s='Height : '}{$product.custommade.user_height|escape:'html':'UTF-8'}{l s=' CM'}</small><br/>{/if}
		{if isset($product.attributes) && $product.attributes}<a href="{$link->getProductLink($product.id_product, $product.link_rewrite, $product.category, null, null, $product.id_shop)|escape:'htmlall':'UTF-8'}">{$product.attributes|replace:'Format : Commander un ': ''|replace:'Format : Commander ce ': ''|replace:'Format : Commander une ': ''|ucfirst|escape:'htmlall':'UTF-8'}</a>{/if}
	</td>
	{*<td class="cart_ref">{if $product.reference}{$product.reference|escape:'htmlall':'UTF-8'}{else}--{/if}</td>*}
	<td class="cart_unit">
		<div class="hidden">{l s='Prix unitaire :'}<br/></div>
		<span class="price" id="product_price_{$product.id_product}_{$product.id_product_attribute}_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}">
			{if !empty($product.gift)}
				<span class="gift-icon">{l s='Gift!'}</span>
			{else}
				{if isset($product.is_discounted) && $product.is_discounted}
					<span style="text-decoration:line-through;">{convertPrice price=$product.price_without_specific_price}</span><br />
				{/if}
				{if !$priceDisplay}
					{convertPrice price=$product.price_wt}
				{else}
					{convertPrice price=$product.price}
				{/if}
			{/if}
		</span>
		{*
		<div class="cart_total hidden">
			<span class="price">
				{if !empty($product.gift)}
					<span class="gift-icon">{l s='Gift!'}</span>
				{else}
					{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}
						{if !$priceDisplay}{displayPrice price=$product.total_customization_wt}{else}{displayPrice price=$product.total_customization}{/if}
					{else}
						{if !$priceDisplay}{displayPrice price=$product.total_wt}{else}{displayPrice price=$product.total}{/if}
					{/if}
				{/if}
			</span>
		</div>
		*}
	</td>
	<td class="cart_quantity"{if isset($customizedDatas.$productId.$productAttributeId) AND $quantityDisplayed == 0} style="text-align: center;"{/if}>
		{if isset($cannotModify) AND $cannotModify == 1}
			<span style="float:left">
				{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}
				{else}
					{$product.cart_quantity-$quantityDisplayed}
				{/if}
			</span>
		{else}
			{if isset($customizedDatas.$productId.$productAttributeId) AND $quantityDisplayed == 0}
				<span id="cart_quantity_custom_{$product.id_product}_{$product.id_product_attribute}_{$product.id_address_delivery|intval}" >{$product.customizationQuantityTotal}</span>
			{/if}
			{if !isset($customizedDatas.$productId.$productAttributeId) OR $quantityDisplayed > 0}
				{strip}<input type="hidden" value="{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}" name="quantity_{$product.id_product}_{$product.id_product_attribute}_0_{$product.id_address_delivery|intval}_hidden" />
				
				<div class="cart_quantity_border">
					<input size="2" type="text" autocomplete="off" class="cart_quantity_input" value="{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}{$customizedDatas.$productId.$productAttributeId|@count}{else}{$product.cart_quantity-$quantityDisplayed}{/if}"  name="quantity_{$product.id_product}_{$product.id_product_attribute}_0_{$product.id_address_delivery|intval}" />
				
					<div class="cart_quantity_button">
						<a rel="nofollow" class="cart_quantity_up" id="cart_quantity_up_{$product.id_product}_{$product.id_product_attribute}_0_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;token={$token_cart}")}" title="{l s='Add'}"></a>
						{if $product.minimal_quantity < ($product.cart_quantity-$quantityDisplayed) OR $product.minimal_quantity <= 1}
						<a rel="nofollow" class="cart_quantity_down" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_0_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "add&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;op=down&amp;token={$token_cart}")}" title="{l s='Subtract'}"></a>
						{else}
						<a class="cart_quantity_down" style="opacity: 0.3;" href="#" id="cart_quantity_down_{$product.id_product}_{$product.id_product_attribute}_0_{$product.id_address_delivery|intval}" title="{l s='You must purchase a minimum of %d of this product.' sprintf=$product.minimal_quantity}"></a>
						{/if}
					</div>
				</div>
				{/strip}
			{/if}
		{/if}
			
		{if !isset($noDeleteButton) || !$noDeleteButton} 
			{if (!isset($customizedDatas.$productId.$productAttributeId) OR $quantityDisplayed) > 0 && empty($product.gift)}
				<div class="cart_delete">
					<a rel="nofollow" class="cart_quantity_delete" id="{$product.id_product}_{$product.id_product_attribute}_0_{$product.id_address_delivery|intval}" href="{$link->getPageLink('cart', true, NULL, "delete=1&amp;id_product={$product.id_product|intval}&amp;ipa={$product.id_product_attribute|intval}&amp;id_address_delivery={$product.id_address_delivery|intval}&amp;token={$token_cart}")}"><img src="{$img_dir}corbeille.png" alt="X" /></a>
				</div>
			{/if} 
		{/if}
	</td>
	<td class="cart_total">
		<span class="price" id="total_product_price_{$product.id_product}_{$product.id_product_attribute}_{$product.id_address_delivery|intval}{if !empty($product.gift)}_gift{/if}">
			{if !empty($product.gift)}
				<span class="gift-icon">{l s='Gift!'}</span>
			{else}
				{if $quantityDisplayed == 0 AND isset($customizedDatas.$productId.$productAttributeId)}
					{if !$priceDisplay}{displayPrice price=$product.total_customization_wt}{else}{displayPrice price=$product.total_customization}{/if}
				{else}
					{if !$priceDisplay}{displayPrice price=$product.total_wt}{else}{displayPrice price=$product.total}{/if}
				{/if}
			{/if}
		</span>
	</td>
</tr>
