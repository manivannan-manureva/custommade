{*
* @version 1.0
* @author 202-ecommerce
* @copyright 2016-2017 202-ecommerce
* @license ?
*}

{if $prodCustomizeStatus == 1}
	<p class="align_justify">
		<a  href="{$link->getModuleLink('custommade', 'default', ['id_product' => {$id_product|escape:'htmlall':'UTF-8'}])|escape:'htmlall':'UTF-8'}" title="{l s='Customize Wall Mural' mod='custommade'}">		
			<button type="button" class="btn btn-success">Customize Wall Mural</button>
		</a>
	</p>
	<br class="clear" />
{/if}