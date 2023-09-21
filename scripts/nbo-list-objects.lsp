;|-------------------Layers List----------------------                                          
 Create a line & text for each layer and have        
 layer properties and text string is layer name      
 for each layer                                                        
------------------------------------------------------ |;     

(defun c:NicoLayers (/ $AcObj $ActDoc $Cntr $Pnt0 $e $l $Pnt1 $Pnt2 $LayerName 
                     $LayerLType $LayerClr $Layer
                    ) 
  (vl-load-com)

  (setq $AcObj (vlax-get-Acad-Object))
  (setq $ActDoc (vla-get-ActiveDocument $AcObj))
  (vla-EndUndoMark $ActDoc)
  (vla-StartUndoMark $ActDoc)

  (setq $Cntr -1)
  (setq $Pnt0 (trans (getpoint "\nBase point") 1 0))
  (WTN:TEXTSTYLE "NLCS-ISO" "NLCS-ISO.ttf")
  (while 
    (and 
      (setq $Layer (tblnext "LAYER" (null $Layer)))
      (setq $LayerName (cdr (assoc 2 $Layer)))
      (setq $LayerLType (cdr (assoc 6 $Layer)))
      (setq $LayerClr (cdr (assoc 62 $Layer)))
    )

    (if 
      (and 
        (setq $Pnt1 (list (+ (car $Pnt0) 800) (cadr $Pnt0) (caddr $Pnt0)))
        (setq $Pnt2 (list (+ (car $Pnt0) 1000) (+ (cadr $Pnt0) 0) (caddr $Pnt0)))
      )
      (progn 
        (WTN:PRINTLAYERLINETYPE $LayerLType $LayerName $Pnt0 $Pnt1 $Pnt2 $LayerClr)
        (setq $Pnt0 (list (car $Pnt0) (+ (cadr $Pnt0) -250) (caddr $Pnt0)))
      )
    )

    (vla-EndUndoMark $ActDoc)
  )
  (princ)
)


;|-------------------Layers Blocks----------------------                                          
   Create a block & text for each block and have                                                               
------------------------------------------------------ |;     

(defun c:NicoBlocks (/ $AcObj $ActDoc $Cntr $Pnt0 $e $l $Pnt1 $Pnt2 $SymbolName 
                     $LayerLType $LayerClr $Block
                    ) 
  (vl-load-com)

  (setq $AcObj (vlax-get-Acad-Object))
  (setq $ActDoc (vla-get-ActiveDocument $AcObj))
  (vla-EndUndoMark $ActDoc)
  (vla-StartUndoMark $ActDoc)

  (setq $Cntr -1)
  (setq $Pnt0 (trans (getpoint "\nBase point") 1 0))
  (WTN:TEXTSTYLE "NLCS-ISO" "NLCS-ISO.ttf")
  (while 
    (and 
      (setq $Block (tblnext "BLOCK" (null $Block)))
      (setq $SymbolName (cdr (assoc 2 $Block)))
    )

    (if (setq $Pnt1 (list (+ (car $Pnt0) 800) (cadr $Pnt0) (caddr $Pnt0))) 

      (progn 
        (WTN:PRINTBLOCKS $SymbolName $Pnt0 $Pnt1)
        (setq $Pnt0 (list (car $Pnt0) (+ (cadr $Pnt0) -1300) (caddr $Pnt0)))
      )
    )

    (vla-EndUndoMark $ActDoc)
  )
  (princ)
)

(defun WTN:PRINTLAYERLINETYPE ($LayerLType $LayerName $Pnt0 $Pnt1 $Pnt2 $LayerClr /) 
  (setvar 'clayer $LayerName)
  (entmake 
    (list 
      (cons 0 "LINE")
      (cons 6 $LayerLType)
      (cons 8 $LayerName)
      (cons 10 $Pnt0)
      (cons 11 $Pnt1)
      (cons 62 $LayerClr)
    )
  )

  (entmake 
    (list 
      (cons 0 "TEXT")
      (cons 1 $LayerName)
      (cons 7 "NLCS-ISO")
      (cons 8 $LayerName)
      (cons 10 $Pnt2)
      (cons 11 $Pnt2)
      (cons 40 130)
      (cons 41 1.0)
      (cons 62 $LayerClr)
      (cons 72 0)
      (cons 73 2)
    )
  )
)


(defun WTN:PRINTBLOCKS ($SymbolName $Pnt0 $Pnt1 /) 
  (setvar 'cLayer "0")
  (setq $thisdrawing (vla-get-activedocument 
                       (vlax-get-acad-object)
                     )
  )
  (setq $mspace (vla-get-modelspace $thisdrawing))
  (vla-InsertBlock $mspace 
                   (vlax-3d-point $Pnt0)
                   $SymbolName
                   50
                   50
                   1
                   0
  )
  (entmakex 
    (list 
      (cons 0 "TEXT")
      (cons 1 $SymbolName)
      (cons 7 "NLCS-ISO")
      (cons 8 "0")
      (cons 10 $Pnt1)
      (cons 11 $Pnt1)
      (cons 40 130)
      (cons 41 1.0)
      (cons 72 0)
      (cons 73 2)
    )
  )
)

(defun WTN:TEXTSTYLE ($textsylename $fontname /) 
  (if (not (tblsearch "style" $textsylename)) 
    (setq $textsylename (entmakex 
                          (list (cons 0 "STYLE") 
                                (cons 100 "AcDbSymbolTableRecord")
                                (cons 100 "AcDbTextStyleTableRecord")
                                (cons 2 $textsylename)
                                (cons 70 0)
                                (cons 40 0.0) ;<- text height not defined
                                (cons 41 1.0)
                                (cons 50 0.0)
                                (cons 71 0)
                                (cons 42 2.0)
                                (cons 3 $fontname)
                                (cons 4 "")
                          )
                        )
    )
  )
  $textsylename
)