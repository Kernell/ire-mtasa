-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2015
-- License		Proprietary Software
-- Version		1.0

class. Image
{
	static
	{
		--
        -- Сводка:
        --     Создает объект Image из указанного файла.
        --
        -- Параметры:
        --   filename:
        --     Строка, содержащая имя файла, из которого нужно создать объект Image.
        --
        -- Возвращает:
        --     Объект Image, создаваемый данным методом.
        FromFile = function( filename, textureFormat, mipmaps, textureEdge )
			local Image = new. Image();
			
			Image.material = dxCreateTexture( filename, textureFormat or "argb", mipmaps == NULL and true or mipmaps, textureEdge or "wrap" );
			
			return Image;
		end;
	};

	-- Сводка:
	--     Создает точную копию данного объекта Image.
	--
	-- Возвращает:
	--     Изображение Image, который создает данный метод, преобразованное
	--     в объект.
	Clone = function()
		local Image = new. Image();
			
		Image.material = cloneElement( this.material );
		
		return Image;
	end;
	--
	-- Сводка:
	--     Получает ширину и высоту данного изображения в пикселях.
	--
	-- Возвращает:
	--     Структура Size, которая представляет ширину и высоту данного
	--     изображения в пикселях.
	Size = function()
		return new. Size( dxGetMaterialSize( this.material ) );
	end;
	--
	-- Сводка:
	--     Сохраняет объект Image в указанный файл.
	--
	-- Параметры:
	--   filename:
	--     Строка, содержащая имя файла, в который нужно сохранить объект Image.
	Save = function( filename )
	
	end;
};
