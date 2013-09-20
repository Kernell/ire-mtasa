-- Author:      	Kernell
-- Version:     	1.0.0


function Offer( name, gender, option_name, tick )
	local Button = MessageBox:Show( name .. ' ' .. gender .. ' Вам ' .. option_name .. '\n\n(Нажмите "М" чтобы включить указатель мыши)', 'Сообщение', MessageBoxButtons.YesNo, MessageBoxIcon.Question );
	
	Button[ 'Да' ].OnClick = function()
		SERVER.ReturnOffer( true, tick );
	end
	
	Button[ 'Нет' ].OnClick = function()
		SERVER.ReturnOffer( false, tick );
	end
end