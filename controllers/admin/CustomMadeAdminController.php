<?php
/**
 * NOTICE OF LICENSE
 *
 * This source file is subject to a commercial license from 202 ecommerce
 * Use, copy, modification or distribution of this source file without written
 * license agreement from 202 ecommerce is strictly forbidden.
 *
 * @author    202 ecommerce <contact@202-ecommerce.com>
 * @copyright Copyright (c) 202 ecommerce 2014
 * @license   Commercial license
 *
 * Support <support@202-ecommerce.com>
 */

if (!defined('_PS_VERSION_')) {
    die(header('HTTP/1.0 404 Not Found'));
}
require_once _PS_MODULE_DIR_.'custommade/custommade.php';
require_once _PS_MODULE_DIR_.'custommade/classes/Universe.php';
class CustomMadeAdminController extends ModuleAdminController
{

    public $custommadeObj;
    public $custModuleFolderName;
    public function __construct()
    {
        $this->bootstrap = true;
        $this->context = Context::getContext();
        $this->table = 'universe';
        $this->identifier = 'id_universe';
        $this->className = 'Universe';
        $this->_defaultOrderBy = 'id_universe';
        $this->show_toolbar_options = true;
        $this->lang = false;
        $this->addRowAction('edit');
        $this->addRowAction('delete');
        $this->custommadeObj = new Custommade();
        $this->custModuleFolderName = _PS_MODULE_DIR_.$this->custommadeObj->name.'/views/img/';
        $this->bulk_actions = array('delete' => array('text' => $this->l('Supprimer sélectionnée'),
                    'confirm' => $this->l('Supprimer les éléments sélectionnés?')), );
        $this->fields_list['universe_name'] = array(
            'title' => $this->l("Nom de l&#39;univers"),
            'align' => 'center',
            'width' => 40,
        );
        $this->fields_list['universe_left'] = array(
            'title' => $this->l('À gauche'),
            'align' => 'center',
            'width' => 40,
        );
        $this->fields_list['universe_top'] = array(
            'title' => $this->l('Sommet'),
            'align' => 'center',
            'width' => 40,
        );
        $this->fields_list['universe_width'] = array(
            'title' => $this->l('Largeur'),
            'align' => 'center',
            'width' => 40,
        );
        $this->fields_list['universe_height'] = array(
            'title' => $this->l('Hauteur'),
            'align' => 'center',
            'width' => 40,
        );
        $this->fields_list['active'] = array(
            'title'  => $this->l('Affiché'),
            'align'  => 'center',
            'width'  => 25,
            'active' => 'active',
            'type'   => 'bool',
        );
        parent::__construct();
    }

    public function renderForm()
    {
        if (empty($this->toolbar_title)) {
            $this->initToolbarTitle();
        }
        $id_universe = (int)Tools::getValue('id_universe');
        if ($id_universe) {
            $count_cover_image = Db::getInstance()->getValue('SELECT `image` FROM `'._DB_PREFIX_.Tools::strtolower($this->table).'` u WHERE u.`id_universe` = '.(int)$id_universe);
            $image = $this->custModuleFolderName.$count_cover_image;
            $ext = pathinfo($image, PATHINFO_EXTENSION);
            $image_url = ImageManager::thumbnail($image, $count_cover_image, 350, $ext, true, true);
        } else {
            $image = '';
            $image_url = '';
        }
        $image_size = file_exists($image) ? filesize($image) / 1000 : false;

        $helper = new HelperForm();
        $this->setHelperDisplay($helper);
        Shop::addTableAssociation($this->table, array('type' => 'shop'));
        $this->fields_form = array(
            'legend' => array(
                'title' => $this->module->l('Add Universe', 'CustomMadeAdmin'),
                //'image' => Tools::getHttpHost(true)._PS_MODULE_DIR_.$this->custommadeObj->name.'/logo.gif'
                'image' => Tools::getHttpHost(true) . __PS_BASE_URI__ . 'modules/'.$this->custommadeObj->name.'/logo.gif'
            ),
            'submit' => array(
                'name' => 'subtmitAddCustommade',
                'title' => $this->module->l('Save', 'CustomMadeAdmin'),
                'class' => (version_compare(_PS_VERSION_, '1.6', '<') ? 'button' : 'btn btn-default pull-right')
            ),
            'input' => array(
                array(
                    'type' => 'text',
                    'label' => $this->module->l('Nom de l\'univers:', 'CustomMadeAdmin'),
                    'name' => 'universe_name',
                    'required' => true,
                    'hint' => $this->l('Caractères invalides:').' <>;=#{}',
                ),
                array(
                    'type' => 'file',
                    'label' => $this->module->l('Photo:', 'CustomMadeAdmin'),
                    'name' => 'image',
                    'image' => $image_url ? $image_url : false,
                    'size' => $image_size,
                    'display_image' => true,
                    'required' => true,
                    'hint' => $this->l('Image format not recognized, allowed formats are: .gif, .jpg, .png'),
                ),
                array(
                    'type' => 'text',
                    'label' => $this->module->l('À gauche:', 'CustomMadeAdmin'),
                    'name' => 'universe_left',
                    'required' => false,
                    'hint' => $this->l('Valeurs acceptées dans :').'%',
                ),
                array(
                    'type' => 'text',
                    'label' => $this->module->l('Sommet:', 'CustomMadeAdmin'),
                    'name' => 'universe_top',
                    'required' => false,
                    'hint' => $this->l('Valeurs acceptées dans :').'%',
                ),
                array(
                    'type' => 'text',
                    'label' => $this->module->l('Largeur:', 'CustomMadeAdmin'),
                    'name' => 'universe_width',
                    'required' => false,
                    'hint' => $this->l('Valeurs acceptées dans :').'%',
                ),
                array(
                    'type' => 'text',
                    'label' => $this->module->l('Hauteur:', 'CustomMadeAdmin'),
                    'name' => 'universe_height',
                    'required' => false,
                    'hint' => $this->l('Valeurs acceptées dans :').'%',
                ),
                array(
                    'type' => 'radio',
                    'label' => $this->l('Affiché:'),
                    'name' => 'active',
                    'required' => false,
                    'class' => 't',
                    'is_bool' => false,
                    'values' => array(
                        array(
                            'id' => 'require_on',
                            'value' => 1,
                            'label' => $this->l('Oui')
                        ),
                        array(
                            'id' => 'require_off',
                            'value' => 0,
                            'label' => $this->l('Non')
                        )
                    )
                ),
            )
        );
        return parent::renderForm();
    }

    public function postProcess()
    {
        if (Tools::getIsset('cancel')) {
            Tools::redirectAdmin(self::$currentIndex.'&token='.Tools::getAdminTokenLite('CustomMadeAdmin'));
        }

        $name = 'image';
        if (Tools::isSubmit('submitAdduniverse') || @$_FILES[$name]['name'] != null && @$_FILES['image']['size'] > 0) {
            $images_types = array(array('id_image_type' => 1,
                                        'name'          => ImageType::getFormatedName('medium'),
                                        'width'         => 150,
                                        'height'        => 150
                                        )
                                );
            $formated_medium = ImageType::getFormatedName('medium');
            foreach ($images_types as $image_type) {
                if ($formated_medium == $image_type['name']) {
                    $target_file = $this->custModuleFolderName . basename($_FILES[$name]["name"]);
                    if ($error = ImageManager::validateUpload($_FILES[$name], Tools::getMaxUploadSize())) {
                        $id_universe = (int)Tools::getValue('id_universe');
                        if (isset($id_universe) && !empty($id_universe) && $id_universe != 0) {
                            //$universe_name = (string)Tools::getValue('universe_name');
                            $datas = array('universe_name'=>(string)Tools::getValue('universe_name'),
                                            'universe_left'=>(string)Tools::getValue('universe_left'),
                                            'universe_top'=>(string)Tools::getValue('universe_top'),
                                            'universe_height'=>(string)Tools::getValue('universe_height'),
                                            'universe_width'=>(string)Tools::getValue('universe_width'));
                            $active = (int)Tools::getValue('active');
                            $this->withoutimageupload($id_universe, $datas, $active);
                        } else {
                            $this->errors[] = $error;
                        }
                    } elseif (!move_uploaded_file($_FILES[$name]['tmp_name'], $target_file)) {
                        $this->errors = Tools::displayError("Une erreur s'est produite lors du chargement de l'image.");
                    } else {
                        $type = $_FILES[$name]['type'];
                        $imgName = $_FILES[$name]['name'];
                        $imageName = explode('.', $imgName);
                        $imageType = explode('/', $type);
                        $id_universe = (int)Tools::getValue('id_universe');
                        if (!ImageManager::resize(
                            $target_file,
                            $this->custModuleFolderName.'universe'.'-'.Tools::stripslashes($imageName[0]).'.'.$imageType[1],
                            (int)$image_type['width'],
                            (int)$image_type['height']
                        )) {
                            $this->errors = Tools::displayError("Une erreur s'est produite lors du téléchargement de l'image miniature.");
                        } else {
                            $datas = array('universe_name'=>(string)Tools::getValue('universe_name'),
                                            'universe_left'=>(string)Tools::getValue('universe_left'),
                                            'universe_top'=>(string)Tools::getValue('universe_top'),
                                            'universe_height'=>(string)Tools::getValue('universe_height'),
                                            'universe_width'=>(string)Tools::getValue('universe_width'));
                            //$universe_name = (string)Tools::getValue('universe_name');
                            $thump = 'universe-'.Tools::stripslashes($imageName[0]).'.'.$imageType[1];
                            $image = $imgName;

                            if (isset($id_universe) && !empty($id_universe) && $id_universe != 0) {

                                $count_cover_image = Db::getInstance()->getValue('
                                    SELECT `image` FROM `'._DB_PREFIX_.Tools::strtolower($this->table).'` u WHERE u.`id_universe` = '.(int)$id_universe);

                                $count_cover_thump = Db::getInstance()->getValue('
                                    SELECT `thump` FROM `'._DB_PREFIX_.Tools::strtolower($this->table).'` u WHERE u.`id_universe` = '.(int)$id_universe);

                                if (file_exists($this->custModuleFolderName.$count_cover_image) && $count_cover_image != $image) {
                                    @unlink($this->custModuleFolderName.$count_cover_image);
                                }
                                if (file_exists($this->custModuleFolderName.$count_cover_thump) && $count_cover_thump != $thump) {
                                    @unlink($this->custModuleFolderName.$count_cover_thump);
                                }
                            }
                        }

                        $active = (int)Tools::getValue('active');
                        $this->imageupload($id_universe, $datas, $image, $thump, $active);
                    }
                }
            }
        }
        return parent::postProcess();
    }

    private function withoutimageupload($id_universe, $datas, $active)
    {
        $left = ($datas['universe_left'] != '') ? $datas['universe_left'] : '0';
        $top = ($datas['universe_top'] != '') ? $datas['universe_top'] : '0';
        $height = ($datas['universe_height'] != '') ? $datas['universe_height'] : '0';
        $width = ($datas['universe_width'] != '') ? $datas['universe_width'] : '0';
        if (isset($id_universe) && !empty($id_universe) && $id_universe != 0) {
            $sql = "UPDATE `"._DB_PREFIX_.Tools::strtolower($this->table)."` SET 
                                                    universe_name = '".$datas['universe_name']."',
                                                    universe_left = '".$left."',
                                                    universe_top = '".$top."',
                                                    universe_height = '".$height."',
                                                    universe_width = '".$width."',
                                                    active = '".$active."'
                                                WHERE id_universe = ".$id_universe;
            if (Db::getInstance()->execute($sql)) {
                Tools::redirectAdmin(self::$currentIndex.'&token='.Tools::getAdminTokenLite('CustomMadeAdmin'));
            } else {
                return false;
            }
        }
    }

    private function imageupload($id_universe, $datas, $image, $thump, $active)
    {
        $left = ($datas['universe_left'] != '') ? $datas['universe_left'] : '0';
        $top = ($datas['universe_top'] != '') ? $datas['universe_top'] : '0';
        $height = ($datas['universe_height'] != '') ? $datas['universe_height'] : '0';
        $width = ($datas['universe_width'] != '') ? $datas['universe_width'] : '0';
        
        if (isset($id_universe) && !empty($id_universe) && $id_universe != 0) {
            $sql = "UPDATE `"._DB_PREFIX_.Tools::strtolower($this->table)."` SET 
                                                    universe_name = '".$datas['universe_name']."',
                                                    universe_left = '".$left."',
                                                    universe_top = '".$top."',
                                                    universe_height = '".$height."',
                                                    universe_width = '".$width."',
                                                    image = '".$image."',
                                                    thump = '".$thump."',
                                                    active = '".$active."'
                                                WHERE id_universe = ".$id_universe;
            if (Db::getInstance()->execute($sql)) {
                Tools::redirectAdmin(self::$currentIndex.'&token='.Tools::getAdminTokenLite('CustomMadeAdmin'));
            } else {
                return false;
            }
        } else {
            $sql =' INSERT INTO `'._DB_PREFIX_.Tools::strtolower($this->table).'` (`universe_name`, `universe_left`,`universe_top`,`universe_height`,`universe_width`,`image`, `thump`, `active`) VALUES ("'.$datas['universe_name'].'","'.$left.'" ,"'.$top.'" ,"'.$height.'","'.$width.'" ,"'.$image.'","'.$thump.'", "'.$active.'")';
            if (Db::getInstance()->execute($sql)) {
                Tools::redirectAdmin(self::$currentIndex.'&token='.Tools::getAdminTokenLite('CustomMadeAdmin'));
            } else {
                return false;
            }
        }
    }

    protected function processBulkDelete()
    {
        if ($this->tabAccess['delete'] === '1') {
            foreach (Tools::getValue($this->table.'Box') as $id_universe) {
                $uniDelete = new Universe((int)$id_universe);
                if (file_exists($this->custModuleFolderName.$uniDelete->image)) {
                    @unlink($this->custModuleFolderName.$uniDelete->image);
                }
                if (file_exists($this->custModuleFolderName.$uniDelete->thump)) {
                    @unlink($this->custModuleFolderName.$uniDelete->thump);
                }
            }
            parent::processBulkDelete();
            return true;
        } else {
            $this->errors[] = Tools::displayError("Vous n'êtes pas autorisé à le supprimer.");
        }
        return false;
    }

    public function processDelete()
    {
        if ($this->tabAccess['delete'] === '1') {
            $uniDelete = $this->loadObject();
            if (file_exists($this->custModuleFolderName.$uniDelete->image)) {
                @unlink($this->custModuleFolderName.$uniDelete->image);
            }
            if (file_exists($this->custModuleFolderName.$uniDelete->thump)) {
                @unlink($this->custModuleFolderName.$uniDelete->thump);
            }
            parent::processDelete();
            return true;
        } else {
            $this->errors[] = Tools::displayError("Vous n'êtes pas autorisé à le supprimer.");
        }
        return false;
    }
}
