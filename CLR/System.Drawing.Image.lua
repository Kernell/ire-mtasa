-- Innovation Roleplay Engine
--
-- Author		Kernell
-- Copyright	© 2011 - 2013
-- License		Proprietary Software
-- Version		1.0

class "System.Drawing.Image"
{
	static
	{
		--
        -- Сводка:
        --     Создает объект System.Drawing.Image из указанного файла.
        --
        -- Параметры:
        --   filename:
        --     Строка, содержащая имя файла, из которого нужно создать объект System.Drawing.Image.
        --
        -- Возвращает:
        --     Объект System.Drawing.Image, создаваемый данным методом.
        FromFile = function( filename, textureFormat, mipmaps, textureEdge )
			local Image = System.Drawing.Image();
			
			Image.material = dxCreateTexture( filename, textureFormat or "argb", mipmaps == NULL and true or mipmaps, textureEdge or "wrap" );
			
			return Image;
		end;
	};
	-- Сводка:
	--     Создает точную копию данного объекта System.Drawing.Image.
	--
	-- Возвращает:
	--     Изображение System.Drawing.Image, который создает данный метод, преобразованное
	--     в объект.
	Clone = function( this )
		local Image = System.Drawing.Image();
			
		Image.material = cloneElement( this.material );
		
		return Image;
	end;
	--
	-- Сводка:
	--     Получает ширину и высоту данного изображения в пикселях.
	--
	-- Возвращает:
	--     Структура System.Drawing.Size, которая представляет ширину и высоту данного
	--     изображения в пикселях.
	Size = function( this )
		return System.Drawing.Size( dxGetMaterialSize( this.material ) );
	end;
	--
	-- Сводка:
	--     Сохраняет объект System.Drawing.Image в указанный файл.
	--
	-- Параметры:
	--   filename:
	--     Строка, содержащая имя файла, в который нужно сохранить объект System.Drawing.Image.
	Save = function( this, filename )
	
	end;
};
